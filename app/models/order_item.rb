class OrderItem < ActiveRecord::Base
  acts_as_taggable
  has_paper_trail
  
  belongs_to :order
  belongs_to :food_item, -> { with_deleted }
  belongs_to :restaurant
  belongs_to :kitchen
  belongs_to :category

  before_create :set_info

  before_save :update_quantity_ordered
  after_save :cache_order_amount

  monetize :unit_price_cents
  monetize :unit_price_without_promotion_cents

  validates_associated :order, :food_item

  validates :order_id,      presence: true
  validates :food_item_id,  presence: true
  validates :quantity,      presence: true, numericality: { greater_than: 0, less_than: 99999999 }
  validates :unit_price,    presence: true, numericality: { greater_than: 0, less_than: 9999999999 }
  validates :unit_price_currency,                    presence: true
  validates :unit_price_without_promotion,           presence: true, numericality: { greater_than: 0, less_than: 9999999999 }
  validates :unit_price_without_promotion_currency,  presence: true
  validate :validate_order_quantity

  def total_price
    unit_price * quantity
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
    self.tags = food_item.tags 
  end

  def update_quantity_ordered
    # Order must be linked to the kitchen to update quantity_ordered here
    if quantity_changed? && order.delivered_to_kitchen? && !order.status_changed? && order.status.placed? 
      inventory.update_column(:quantity_ordered, inventory.quantity_ordered + (quantity - quantity_was))
    end
  end

  def cache_order_amount
    if unit_price_cents_changed? || unit_price_currency_changed? || quantity_changed?
      order.price = order.items.map(&:total_price).inject(0, :+) 
      order.save
    end
  end

  def validate_order_quantity
    if order&.status&.wip?
      unit_price_dollars = unit_price.dollars.to_f

      if unit_price_dollars > 0
        min_quantity = food_item.min_order_price / unit_price_dollars
        min_quantity = (min_quantity * 100).ceil / 100.0
        errors.add(:base, "The Minimum Order Quantity is #{price_format(food_item.min_order_price)}") if quantity < min_quantity

        if food_item.max_order_price.present?
          max_quantity = food_item.max_order_price / unit_price_dollars
          max_quantity = (max_quantity * 100).floor / 100.0
          errors.add(:base, "The Maximum Order Quantity is #{price_format(food_item.max_order_price)}") if quantity > max_quantity
        end
      end
    end
  end

  def price_format(price)
    ActionController::Base.helpers.humanized_money_with_symbol(Money.from_amount(price, unit_price_currency))
  end
end