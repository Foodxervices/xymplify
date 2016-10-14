class AddNameToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :name, :string

    OrderItem.all.each do |item|
      item.update_column(:name, item.food_item&.name)
    end
  end
end
