class Conversion < ActiveRecord::Base
  belongs_to :food_item, inverse_of: :conversions
  validates :unit,     presence: true
  validates :rate,     presence: true
end