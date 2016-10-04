class Order < ActiveRecord::Base
  extend Enumerize

  has_many :items, class_name: "OrderItem", dependent: :destroy
  belongs_to :supplier 
  belongs_to :kitchen
  belongs_to :user 

  validates_associated :supplier, :kitchen, :user

  validates :user_id,      presence: true
  validates :supplier_id,  presence: true
  validates :kitchen_id,   presence: true

  enumerize :status, in: [:wip, :placed, :shipped, :cancelled], default: :wip

  def price 
    items.includes(:food_item).map(&:total_price).inject(0, :+)
  end

  def code
    id.to_s.rjust(6,"0")
  end
end