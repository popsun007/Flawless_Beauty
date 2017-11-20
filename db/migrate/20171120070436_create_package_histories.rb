class CreatePackageHistories < ActiveRecord::Migration
  def change
    create_table :package_histories do |t|
      t.text :signature
      t.references :user, index: true, foreign_key: true
      t.references :package, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
