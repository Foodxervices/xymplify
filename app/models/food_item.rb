class FoodItem < ActiveRecord::Base
  validates :code,        presence: true
  validates :name,        presence: true 
  validates :unit,        presence: true 
  validates :unit_price,  presence: true 
end