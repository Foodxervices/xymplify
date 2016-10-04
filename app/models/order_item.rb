class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :food_item

  monetize :unit_price_cents

  validates_associated :order, :food_item

  validates :order_id,      presence: true
  validates :food_item_id,  presence: true
  validates :quantity,      presence: true

  def current_unit_price
    order.status.wip? ? food_item.unit_price : unit_price
  end

  def total_price
    current_unit_price * quantity
  end
end