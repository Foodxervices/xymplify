class FoodItem < ActiveRecord::Base
  monetize :unit_price_cents

  belongs_to :supplier
  belongs_to :user
  validates_associated :supplier, :user

  validates :code,        presence: true
  validates :name,        presence: true 
  validates :unit_price,  presence: true
  validates :brand,       presence: true
  validates :supplier_id, presence: true
  validates :unit_price_currency, presence: true
  validates :current_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :quantity_ordered, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_currency 

  private
  def set_currency
    if unit_price_currency.blank? 
      self.unit_price_currency = supplier&.currency
    end
  end
end