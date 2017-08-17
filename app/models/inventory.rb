class Inventory < ActiveRecord::Base
  has_paper_trail
  belongs_to :restaurant
  belongs_to :kitchen
  belongs_to :food_item, -> { with_deleted }

  validates :restaurant_id,   presence: true
  validates :kitchen_id,      presence: true
  validates :food_item_id,    presence: true
  validates :current_quantity,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 99999999 }
  validates :quantity_ordered,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 99999999 }

  before_save :cache_restaurant

  before_update :update_analytic

  def name
    food_item&.name
  end
  alias_method :long_name, :name

  private
  def cache_restaurant
    self.restaurant_id = food_item.restaurant_id if restaurant_id.nil?
  end

  def update_analytic
    a = Analytic.find_or_initialize_by(restaurant_id: restaurant_id, kitchen_id: kitchen_id, start_period: Time.now.beginning_of_month)
    a.current_quantity += current_quantity - current_quantity_was
    a.quantity_ordered += quantity_ordered - quantity_ordered_was
    a.save
  end
end