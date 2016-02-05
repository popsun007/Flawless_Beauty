class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :member_id
      t.string :full_name
      t.string :email
      t.string :password
      t.string :user_level

      t.timestamps null: false
    end
  end
end
