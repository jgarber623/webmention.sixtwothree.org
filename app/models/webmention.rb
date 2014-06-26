class Webmention < ActiveRecord::Base
  validates_presence_of :source, :target
  validates_format_of   :source, :target, :with => URI::regexp(%w(http https))

  def verified?
    !verified_at.nil?
  end

  def verify
    agent = Mechanize.new

    # [ ] verify that source and target are valid URLs?
    # [ ] verify that target exists and accepts webmentions
    # [x] verify that source links to target
    # [ ] if source does not link to target (410 or no link_with), delete webmention

    if body = agent.get(source)
      if !body.link_with(href: target).nil?
        update_attribute(:verified_at, Time.now.utc)
      end
    end
  end

  def self.verify_all
    where(verified_at: nil).each(&:verify)
  end
end