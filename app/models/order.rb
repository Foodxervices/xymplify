class Order < ActiveRecord::Base
  has_paper_trail :unless => Proc.new { |order| order.status.wip? || order.status.confirmed? }

  extend Enumerize
  monetize :price_cents

  before_create :cache_restaurant
  before_create :set_name

  before_save :set_status_updated_at

  after_save :set_item_price

  has_many :items, class_name: "OrderItem", dependent: :destroy
  has_many :gsts, -> { includes :order },  class_name: "OrderGst",  dependent: :destroy
  has_many :alerts, as: :alertable

  belongs_to :supplier
  belongs_to :kitchen
  belongs_to :user
  belongs_to :restaurant

  has_attached_file :attachment
  validates_attachment :attachment,
                       :content_type => { :content_type => Rails.application.config.upload_file_type },
                       :size => { :less_than => 5.megabyte }
  before_post_process { false }

  validates :user_id,      presence: true
  validates :supplier_id,  presence: true
  validates :kitchen_id,   presence: true
  validates :outlet_name,    presence: true
  validates :outlet_address, presence: true
  validates :outlet_phone,   presence: true
  validates :request_for_delivery_start_at, presence: true, if: '!status.wip?'
  validates :request_for_delivery_end_at,   presence: true, if: '!status.wip?'

  enumerize :status, in: [:wip, :confirmed, :placed, :accepted, :declined, :delivered, :cancelled], default: :wip

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :gsts,  reject_if: :all_blank, allow_destroy: true

  delegate :currency, to: :supplier, allow_nil: true

  def long_name
    name + ' - ' + supplier.name
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

  def date_of_delivery
    delivered_at.present? ? delivered_at : request_for_delivery_start_at
  end

  def validate_request_date
    if request_for_delivery_start_at.present? && request_for_delivery_end_at.present? && request_for_delivery_start_at >= request_for_delivery_end_at
      errors.add(:base, "Please ensure that request for delivery end date after start date.")
    end

    if request_for_delivery_start_at.present?
      if !supplier.valid_delivery_date?(request_for_delivery_start_at)
        errors.add(:base, "Request for delivery start date is invalid.")
      elsif request_for_delivery_start_at < supplier.next_available_delivery_date
        errors.add(:base, "Please ensure that request for delivery start date after #{supplier.next_available_delivery_date.try(:strftime, '%a, %d %b %Y')}.")
      end
    end

    if request_for_delivery_end_at.present?
      if !supplier.valid_delivery_date?(request_for_delivery_end_at)
        errors.add(:base, "Request for delivery end date is invalid.")
      elsif request_for_delivery_end_at < supplier.next_available_delivery_date
        errors.add(:base, "Please ensure that request for delivery end date after #{supplier.next_available_delivery_date.try(:strftime, '%a, %d %b %Y')}.")
      end
    end
  end

  private
  def cache_restaurant
    self.restaurant_id = kitchen.restaurant_id
  end

  def set_name
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

  def set_status_updated_at
    if status_changed?
      self.status_updated_at = Time.zone.now
      self.send("#{status}_at=", status_updated_at) if !status.wip? && !status.confirmed?
    end
  end

  def set_item_price
    if delivered_to_kitchen?
      items.includes(:food_item, :order).each do |item|
        inventory = item.inventory

        case status_change
          when ["confirmed", "placed"]
            inventory.quantity_ordered = inventory.quantity_ordered + item.quantity
          when ["accepted", "delivered"]
            inventory.current_quantity = inventory.current_quantity + item.quantity
            inventory.quantity_ordered = inventory.quantity_ordered - item.quantity
          when ["placed", "cancelled"], ["accepted", "cancelled"], ["placed", "declined"]
            inventory.quantity_ordered = inventory.quantity_ordered - item.quantity
        end

        inventory.save if inventory.changed?
      end
    end
  end
end