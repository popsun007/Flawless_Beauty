class ChangeIntegerLimitToUsers < ActiveRecord::Migration
  def change
  	change_column :users, :phone, :varchar, limit: 12
  end
end
