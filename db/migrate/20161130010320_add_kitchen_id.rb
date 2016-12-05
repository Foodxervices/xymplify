class AddKitchenId < ActiveRecord::Migration
  def change
    add_reference :order_items, :kitchen, index: true
    add_reference :order_gsts, :kitchen, index: true
    add_reference :messages, :kitchen, index: true
  end
end
