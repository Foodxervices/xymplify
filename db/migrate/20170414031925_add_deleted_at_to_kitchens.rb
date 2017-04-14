class AddDeletedAtToKitchens < ActiveRecord::Migration
  def change
    add_column :kitchens, :deleted_at, :datetime
    add_index :kitchens, :deleted_at
  end
end
