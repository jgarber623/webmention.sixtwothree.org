class ChangeStatusToVerified < ActiveRecord::Migration
  def change
    rename_column :webmentions, :status, :verified
  end
end
