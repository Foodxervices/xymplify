class FoodItem < ActiveRecord::Base
  extend Enumerize

  validates :code,        presence: true
  validates :name,        presence: true 
  validates :unit,        presence: true 
  validates :unit_price,  presence: true 

  enumerize :unit, in: [:pack, :kg, :litre, :can]
end