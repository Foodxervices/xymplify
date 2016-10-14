class Order < ActiveRecord::Base
  has_paper_trail

  extend Enumerize

  before_save :cache_restaurant
  before_save :set_delivery_at
  before_save :set_name
  after_save :set_item_price

  has_many :items, class_name: "OrderItem", dependent: :destroy
  has_many :gsts,  class_name: "OrderGst",  dependent: :destroy
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
  accepts_nested_attributes_for :gsts,  reject_if: :all_blank, allow_destroy: true

  delegate :currency, to: :supplier, allow_nil: true

  def price 
    items.includes(:food_item).map(&:total_price).inject(0, :+)
  end

  def self.price 
    all.map(&:price).inject(0, :+)
  end

  def gst
    gsts.amount
  end

  def self.gst 
    all.map(&:gst).inject(0, :+)
  end

  def price_with_gst
    price + gst
  end

  def self.price_with_gst
    all.map(&:price_with_gst).inject(0, :+)
  end

  private 
  def cache_restaurant
    self.restaurant_id = kitchen.restaurant_id if restaurant_id.nil?
  end

  def set_name
    self.name = "PO #{id.to_s.rjust(6,"0")}" if name.blank?
  end

  def set_delivery_at
    if status_change == ["placed", "shipped"]
      self.delivery_at = Time.zone.now
    end
  end

  def set_item_price
    items.includes(:food_item).each do |item|
      food_item = item.food_item
      
      case status_change 
        when ["wip", "placed"]
          food_item.update_column(:quantity_ordered, food_item.quantity_ordered + item.quantity)
        when ["placed", "shipped"] 
          food_item.update_columns(current_quantity: food_item.current_quantity + item.quantity, quantity_ordered: food_item.quantity_ordered - item.quantity)
        when ["placed", "cancelled"]
          food_item.update_columns(quantity_ordered: food_item.quantity_ordered - item.quantity)
      end
    end
  end
end