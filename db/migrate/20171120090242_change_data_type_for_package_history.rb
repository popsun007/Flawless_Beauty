class ChangeDataTypeForPackageHistory < ActiveRecord::Migration
  def change
    change_column :package_histories, :signature, :string
  end
end
