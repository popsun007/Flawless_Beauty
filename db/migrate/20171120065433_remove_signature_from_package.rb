class RemoveSignatureFromPackage < ActiveRecord::Migration
  def change
    remove_column :packages, :signature, :text
  end
end
