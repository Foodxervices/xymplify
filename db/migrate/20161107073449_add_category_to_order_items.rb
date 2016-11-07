class AddCategoryToOrderItems < ActiveRecord::Migration
  def change
    add_reference :order_items, :category, index: true

    OrderItem.all.each do |order_item|
      order_item.update_column(:category_id, order_item.food_item.category_id)
    end
  end
end
