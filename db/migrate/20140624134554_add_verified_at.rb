class AddVerifiedAt < ActiveRecord::Migration
  def change
    add_column :webmentions, :verified_at, :datetime
  end
end
