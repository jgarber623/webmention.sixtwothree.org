class AddStatusToWebmentions < ActiveRecord::Migration
  def change
    add_column :webmentions, :status, :boolean
  end
end
