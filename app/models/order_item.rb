class OrderItem < ActiveRecord::Base
  acts_as_taggable
  has_paper_trail :unless => Proc.new { |item| item.order.status.wip? || item.order.status.confirmed? }

  belongs_to :order
  belongs_to :food_item, -> { with_deleted }
  belongs_to :restaurant
  belongs_to :kitchen
  belongs_to :category

  before_create :set_info

  before_save :update_quantity_ordered

  monetize :unit_price_cents
  monetize :unit_price_without_promotion_cents

  validates :order_id,      presence: true
  validates :food_item_id,  presence: true
  validates :quantity,      presence: true, numericality: { greater_than: 0, less_than: 99999999 }
  validates :unit_price,    presence: true, numericality: { greater_than: 0, less_than: 9999999999 }
  validates :unit_price_currency,                    presence: true
  validates :unit_price_without_promotion,           presence: true, numericality: { greater_than: 0, less_than: 9999999999 }
  validates :unit_price_without_promotion_currency,  presence: true

  def total_price
    unit_price * quantity
  end

  def self.total_price
    all.includes(:order).map(&:total_price).inject(0, :+)
  end

  def inventory
    Inventory.where(food_item_id: food_item_id, kitchen_id: order.kitchen_id, restaurant_id: order.restaurant_id).first_or_create
  end

  private
  def set_info
    self.restaurant_id = order.restaurant_id
    self.kitchen_id = order.kitchen_id
    self.name = food_item.name
    self.category_id = food_item.category_id
    self.tag_list = food_item.tag_list
  end

  def update_quantity_ordered
    # Order must be linked to the kitchen to update quantity_ordered here
    if quantity_changed? && order.delivered_to_kitchen? && !order.status_changed? && order.status.placed?
      inventory.update_column(:quantity_ordered, inventory.quantity_ordered + (quantity - quantity_was))
    end
  end
end