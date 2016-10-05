class Order < ActiveRecord::Base
  extend Enumerize

  has_many :items, class_name: "OrderItem", dependent: :destroy
  belongs_to :supplier 
  belongs_to :kitchen
  belongs_to :user 
  has_one :restaurant, through: :kitchen

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
end