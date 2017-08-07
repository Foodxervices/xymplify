class DishItem < ActiveRecord::Base
  belongs_to :dish
  belongs_to :food_item

  validates :unit_rate, presence: true, numericality: { greater_than: 0, less_than: 9999999999 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }

  def unit_price
    food_item&.unit_price / unit_rate || 0
  end

  def total_price
    unit_price * quantity
  end

  def food_quantity
    quantity / unit_rate
  end

  def self.total_price
    all.map(&:total_price).inject(0, :+)
  end
end