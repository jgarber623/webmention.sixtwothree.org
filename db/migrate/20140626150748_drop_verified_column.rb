class DropVerifiedColumn < ActiveRecord::Migration
  def up
    remove_column :webmentions, :verified
  end

  def down
    add_column :webmentions, :verified, :boolean
  end
end
