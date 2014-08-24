class AddWebmentionTypeToWebmentions < ActiveRecord::Migration
  def change
    add_column :webmentions, :webmention_type, :string
  end
end
