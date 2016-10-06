class Order < ActiveRecord::Base
  has_paper_trail

  extend Enumerize

  before_save :cache_restaurant
  after_save :set_item_price

  has_many :items, class_name: "OrderItem", dependent: :destroy
  belongs_to :supplier 
  belongs_to :kitchen
  belongs_to :user 
  belongs_to :restaurant

  validates_associated :supplier, :kitchen, :user

  validates :user_id,      presence: true
  validates :supplier_id,  presence: true
  validates :kitchen_id,   presence: true

  enumerize :status, in: [:wip, :placed, :shipped, :cancelled], default: :wip

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true

  def price 
    items.includes(:food_item, :order).map(&:total_price).inject(0, :+)
  end

  def self.price 
    all.map(&:price).inject(0, :+)
  end

  def name
    "PO #{code}"
  end

  def code
    id.to_s.rjust(6,"0")
  end

  private 
  def cache_restaurant
    self.restaurant_id = kitchen.restaurant_id if restaurant_id.nil?
  end

  def set_item_price
    items.includes(:food_item).each do |item|
      food_item = item.food_item

      case status_change 
        when ["wip", "placed"]
          item.update_columns(unit_price_cents: food_item.unit_price_cents, unit_price_currency: food_item.unit_price_currency)
          food_item.update_column(:quantity_ordered, food_item.quantity_ordered + item.quantity)
        when ["placed", "shipped"] 
          food_item.update_columns(current_quantity: food_item.current_quantity + item.quantity, quantity_ordered: food_item.quantity_ordered - item.quantity)
        when ["placed", "cancelled"]
          food_item.update_columns(quantity_ordered: food_item.quantity_ordered - item.quantity)
      end
    end
  end
end