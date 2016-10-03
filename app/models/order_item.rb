class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :food_item

  validates_associated :order, :food_item

  validates :order_id,      presence: true
  validates :food_item_id,  presence: true
  validates :quantity,      presence: true
end