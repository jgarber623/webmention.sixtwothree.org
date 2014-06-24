class Webmention < ActiveRecord::Base
  validates_presence_of :source, :target
  validates_format_of   :source, :target, :with => URI::regexp(%w(http https))

  def verify
    agent = Mechanize.new

    if body = agent.get(self.source)
      self.verified = body.link_with(href: self.target) != nil

      if self.verified
        self.verified_at = Time.now.utc
      end

      self.save
    end
  end
end