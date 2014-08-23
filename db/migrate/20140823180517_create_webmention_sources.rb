class CreateWebmentionSources < ActiveRecord::Migration
  def up
    create_table :webmention_sources do |t|
      t.belongs_to :webmention
      t.text :html
      t.text :json
      t.timestamps
    end
  end

  def down
    drop_table :webmention_sources
  end
end
