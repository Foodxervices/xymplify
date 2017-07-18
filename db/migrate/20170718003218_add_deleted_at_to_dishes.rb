class AddDeletedAtToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :deleted_at, :datetime
    add_index :dishes, :deleted_at
  end
end
