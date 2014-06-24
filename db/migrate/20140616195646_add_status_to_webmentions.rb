class AddStatusToWebmentions < ActiveRecord::Migration
  def change
    add_column :webmentions, :status, :boolean, default: 0
  end
end
