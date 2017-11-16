class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :price
      t.integer :count
      t.text :signature

      t.timestamps null: false
    end
  end
end
