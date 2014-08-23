class WebmentionSource < ActiveRecord::Base
  belongs_to :webmention

  validates :webmention, :html, :json, presence: true
end