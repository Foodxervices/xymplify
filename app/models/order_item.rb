class OrderItem < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :order
  belongs_to :food_item
  belongs_to :restaurant

  before_save :cache_restaurant

  monetize :unit_price_cents

  validates_associated :order, :food_item

  validates :order_id,      presence: true
  validates :food_item_id,  presence: true
  validates :quantity,      presence: true

  def name 
    food_item&.name
  end

  def total_price
    unit_price * quantity
  end

  private 
  def cache_restaurant
    self.restaurant_id = order.restaurant_id if restaurant_id.nil?
  end
end