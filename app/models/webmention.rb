class Webmention < ActiveRecord::Base
  validates_presence_of :source, :target
  validates_format_of   :source, :with => URI::regexp(%w(http https))
  validates_format_of   :target, :with => %r{\Ahttp://sixtwothree.org/?}

  def verified?
    !verified_at.nil?
  end

  def verify
    agent = Mechanize.new

    agent.user_agent = 'http://sixtwothree.org/ (http://webmention.org/)'

    if target_accepts_webmentions?(agent.get(target)) && source_links_to_target?(agent.get(source))
      update_attribute(:verified_at, Time.now.utc)
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

  def source_links_to_target?(page)
    # If source and target are on the same domain, target should be relative
    if URI.parse(source).host == URI.parse(target).host
      target.sub! 'http://sixtwothree.org/', '/'
    end

    # Verify that source links to target (with or without trailing slash)
    page.link_with(href: %r{#{target}|#{target.sub(/.*\/+?$/, '')}}).present?
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