class DishItem < ActiveRecord::Base
  belongs_to :dish
  belongs_to :food_item

  validates :quantity, presence: true

  def total_price
    food_item.unit_price * quantity
  end
end