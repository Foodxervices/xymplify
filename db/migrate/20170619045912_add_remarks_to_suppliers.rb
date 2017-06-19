class AddRemarksToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :remarks, :text
  end
end
