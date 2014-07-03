class Webmention < ActiveRecord::Base
  validates_presence_of :source, :target
  validates_format_of   :source, :with => URI::regexp(%w(http https))
  validates_format_of   :target, :with => /\Ahttp:\/\/sixtwothree.org(\/?)/

  def verified?
    !verified_at.nil?
  end

  def verify
    agent = Mechanize.new

    # [ ] verify that target exists and accepts webmentions
    # [ ] if source does not link to target (410 or no link_with), delete webmention

    if body = agent.get(source)
      # If source and target are on the same domain, target should be relative
      if URI.parse(source).host == URI.parse(target).host
        target.sub! 'http://sixtwothree.org/', '/'
      end

      # Verify that source links to target (with or without trailing slash)
      if body.link_with(href: %r{#{target}|#{target.sub(/.*\/+?$/, '')}}).present?
        update_attribute(:verified_at, Time.now.utc)
      end
    end
  end

  def self.verify_all
    where(verified_at: nil).each(&:verify)
  end
end