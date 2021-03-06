class Webmention < ActiveRecord::Base
  has_one :webmention_source, dependent: :destroy

  validates :source, :target, presence: true
  validates :source, format: { :with => URI::regexp(%w(http https)) }
  validates :target, format: { :with => %r{\Ahttp://sixtwothree.org/?} }

  def as_json(options = {})
    webmention_source ? attributes.merge(entry: Microformats2.parse(webmention_source.html).entries.first) : attributes
  end

  def verified?
    !verified_at.nil?
  end

  def verify
    agent = Mechanize.new

    agent.user_agent = 'http://sixtwothree.org/ (http://webmention.org/)'

    source_page = agent.get(source)

    if target_accepts_webmentions?(agent.get(target)) && source_links_to_target?(source_page)
      collection = Microformats2.parse(source_page.body)
      entry_properties = collection.entries.first.to_hash[:properties]

      update_attributes(verified_at: Time.now.utc, webmention_type: get_type(entry_properties))

      WebmentionSource.where(webmention_id: id).first_or_create(html: source_page.body, json: collection.to_json)
    else
      delete
    end
  rescue Mechanize::ResponseCodeError => err
    case err.response_code
      when '404', '410'; delete
    end
  end

  def self.verify_all
    where(verified_at: nil).each(&:verify)
  end

  private

  def get_type(properties)
    if properties.has_key?(:like_of)
      'like'
    elsif properties.has_key?(:in_reply_to)
      'reply'
    elsif properties.has_key?(:repost_of)
      'repost'
    else
      'reference'
    end
  end

  def source_links_to_target?(page)
    if URI.parse(source).host == URI.parse(target).host
      # If source and target are on the same domain, target should be relative
      regex = %r{#{target}|#{target.sub('http://sixtwothree.org/', '/')}}
    else
      # Check for links to target (with or without trailing slash)
      regex = %r{#{target}|#{target.sub(/.*\/+?$/, '')}}
    end

    page.link_with(href: regex).present?
  end

  def target_accepts_webmentions?(page)
    if page.header.key? 'link'
      # Search for endpoint in Link header
      supported = page.header['link'].match(/<((?:https?:\/\/)?[^>]+)>; rel="(?:[^>]*\s+|\s*)(?:webmention|http:\/\/webmention.org\/?)(?:\s*|\s+[^>]*)"/i)
    else
      # Search for endpoint in <link> and <a> elements
      supported = page.search('link[rel~="webmention"]', 'link[rel~="http://webmention.org/"]', 'a[rel~="webmention"]', 'a[rel~="http://webmention.org/"]').first
    end

    supported
  end
end