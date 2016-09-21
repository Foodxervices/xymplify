class SupplierBelongsToRestaurant < ActiveRecord::Migration
  def change
    add_reference :suppliers, :restaurant, index: true
  end
end
