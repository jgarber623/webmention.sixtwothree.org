class AddWebmentionTypeToWebmentions < ActiveRecord::Migration
  def up
    add_column :webmentions, :webmention_type, :string, default: 'reference'

    Webmention.find_each do |webmention|
      webmention.webmention_type = 'reference'
      webmention.save!
    end
  end

  def down
    remove_column :webmentions, :webmention_type
  end
end
