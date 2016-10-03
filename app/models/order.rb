class Order < ActiveRecord::Base
  extend Enumerize

  has_many :items, class_name: "OrderItem"
  belongs_to :supplier 
  belongs_to :kitchen

  validates_associated :supplier, :kitchen

  validates :supplier_id,  presence: true
  validates :kitchen_id,   presence: true

  enumerize :status, in: [:wip, :placed, :shipped, :cancelled], default: :wip
end