class CreateWebmentions < ActiveRecord::Migration
  def up
    create_table :webmentions do |t|
      t.string :source
      t.string :target
      t.timestamps
    end
  end

  def down
    drop_table :webmentions
  end
end
