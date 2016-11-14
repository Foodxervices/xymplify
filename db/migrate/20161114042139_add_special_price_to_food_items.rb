class AddSpecialPriceToFoodItems < ActiveRecord::Migration
  def change
    add_monetize :food_items, :unit_price_without_promotion
    add_monetize :order_items, :unit_price_without_promotion

    FoodItem.all.each do |food_item|
      food_item.update_columns(unit_price_without_promotion_cents: food_item.unit_price_cents, unit_price_without_promotion_currency: food_item.unit_price_currency)
    end

    OrderItem.all.each do |order_item|
      order_item.update_columns(unit_price_without_promotion_cents: order_item.unit_price_cents, unit_price_without_promotion_currency: order_item.unit_price_currency)
    end
  end
end
