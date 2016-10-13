class OrderItem < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :order
  belongs_to :food_item
  belongs_to :restaurant

  before_save :cache_restaurant
  before_save :update_quantity_ordered

  monetize :unit_price_cents

  validates_associated :order, :food_item

  validates :order_id,      presence: true
  validates :food_item_id,  presence: true
  validates :quantity,      presence: true, numericality: { greater_than: 0 }

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

  def update_quantity_ordered
    if quantity_changed? && !order.status_changed? && order.status.placed? 
      food_item.update_column(:quantity_ordered, food_item.quantity_ordered + (quantity - quantity_was))
    end
  end
end