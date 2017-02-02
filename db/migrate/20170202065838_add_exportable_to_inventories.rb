class AddExportableToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :exportable, :bool, default: false

    Inventory.where('current_quantity > 0 OR quantity_ordered > 0').update_all(exportable: true)
  end
end
