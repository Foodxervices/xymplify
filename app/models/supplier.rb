class Supplier < ActiveRecord::Base
  before_destroy :check_for_food_items

  belongs_to :restaurant
  has_many :food_items

  validates :name,            presence: true
  validates :restaurant_id,   presence: true
  validates :email,           email: true

  def country_name
    ISO3166::Country[country]
  end

  def check_for_food_items
    return true if food_items.count == 0
    errors.add :base, "Cannot delete supplier with food items"
    false
  end
end
