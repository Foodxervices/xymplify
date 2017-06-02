class RemoveColumnExportable < ActiveRecord::Migration
  def change
    remove_column :inventories, :exportable
  end
end
