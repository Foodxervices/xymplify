class DishItem < ActiveRecord::Base
  belongs_to :dish
  belongs_to :food_item

  validates :quantity, presence: true

  def unit_price
    food_item&.unit_price || 0
  end

  def total_price
    unit_price * quantity
  end

  def self.total_price
    all.map(&:total_price).inject(0, :+)
  end
end