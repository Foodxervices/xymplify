class AddUnitPriceForDishRequisitionItems < ActiveRecord::Migration
  def change
    add_monetize :dish_requisition_items, :unit_price
    add_monetize :dish_requisitions, :price
  end
end
