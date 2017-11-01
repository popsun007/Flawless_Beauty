class AddBirthdayToUsers < ActiveRecord::Migration
  def change
    change_column :users, :birthday, :date, default: 'now()'
  end
end
