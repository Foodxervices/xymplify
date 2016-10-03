class FoodItem < ActiveRecord::Base
  has_paper_trail

  self.inheritance_column = :_type_disabled
  
  monetize :unit_price_cents

  before_save :cache_restaurant

  belongs_to :supplier
  belongs_to :user
  belongs_to :kitchen
  belongs_to :restaurant
  
  validates_associated :supplier, :user, :kitchen

  validates :code,        presence: true
  validates :name,        presence: true 
  validates :unit_price,  presence: true
  validates :brand,       presence: true
  validates :supplier_id, presence: true
  validates :user_id,     presence: true
  validates :kitchen_id,  presence: true
  validates :unit_price_currency, presence: true
  validates :current_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :quantity_ordered, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_attached_file :image, styles: { thumb: "80x80#", medium: "400x400#" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_validation :set_currency, if: 'unit_price_currency.blank?'

  private 
  def set_currency
    self.unit_price_currency = supplier&.currency 
  end

  def cache_restaurant
    self.restaurant_id = kitchen.restaurant_id if kitchen_id_changed?
  end
end