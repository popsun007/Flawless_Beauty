class AddBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date, default: Date.today
  end
end
