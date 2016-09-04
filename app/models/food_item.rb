class FoodItem < ActiveRecord::Base
  extend Enumerize

  belongs_to :supplier
  belongs_to :user
  validates_associated :supplier, :user

  validates :code,        presence: true
  validates :name,        presence: true 
  validates :unit,        presence: true 
  validates :unit_price,  presence: true
  validates :supplier_id, presence: true
  validates :current_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :quantity_ordered, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enumerize :unit, in: [:pack, :kg, :litre, :can]
end