class RemoveUserIdFromPackageHistory < ActiveRecord::Migration
  def change
    remove_column :package_histories, :user_id, :integer
  end
end
