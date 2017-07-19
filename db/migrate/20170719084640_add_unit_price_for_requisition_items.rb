class AddUnitPriceForRequisitionItems < ActiveRecord::Migration
  def change
    add_monetize :requisition_items, :unit_price
  end
end
