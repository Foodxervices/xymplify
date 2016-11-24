class AddSpecialPriceToFoodItems < ActiveRecord::Migration
  def change
    add_monetize :food_items, :unit_price_without_promotion
    add_monetize :order_items, :unit_price_without_promotion
  end
end
