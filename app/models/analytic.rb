class Analytic < ActiveRecord::Base
  belongs_to :kitchen
  belongs_to :restaurant

  validates :restaurant_id,     presence: true
  validates :kitchen_id,        presence: true
  validates :current_quantity,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }
  validates :quantity_ordered,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }
end