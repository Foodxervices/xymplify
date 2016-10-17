class Order < ActiveRecord::Base
  has_paper_trail

  extend Enumerize

  before_save :cache_restaurant
  before_save :set_placed_at
  before_save :set_delivery_at
  before_save :set_name
  after_save :set_item_price

  has_many :items, class_name: "OrderItem", dependent: :destroy
  has_many :gsts,  class_name: "OrderGst",  dependent: :destroy
  has_many :alerts, as: :alertable
  
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

  def changed_status_at
    case status.to_s
    when 'placed'
      return placed_at
    when 'shipped'
      return delivery_at
    else
      return updated_at
    end
  end

  private 
  def cache_restaurant
    self.restaurant_id = kitchen.restaurant_id if restaurant_id.nil?
  end

  def set_name
    if name.blank?
      today = Time.new
      current_month = today.strftime("%y/%m")
      latest_order_in_current_month = restaurant.orders.where(created_at: today.at_beginning_of_month..today.at_end_of_month).order(:id).last
      
      if latest_order_in_current_month.nil?
        no = "0001"
      else
        no = (latest_order_in_current_month.name[-4..-1].to_i + 1).to_s.rjust(4,"0")
      end
      
      self.name = "Q" + current_month + '/' + no
    end
  end

  def set_delivery_at
    if status_change == ["placed", "shipped"]
      self.delivery_at = Time.zone.now
    end
  end

  def set_placed_at
    if status_change == ["wip", "placed"]
      self.placed_at = Time.zone.now
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