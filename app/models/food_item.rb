class FoodItem < ActiveRecord::Base
  attr_accessor :brand_name

  belongs_to :supplier
  belongs_to :brand
  belongs_to :user
  validates_associated :supplier, :user, :brand

  validates :code,        presence: true
  validates :name,        presence: true 
  validates :unit_price,  presence: true
  validates :brand_id,    presence: true, if: 'brand_name.blank?'
  validates :brand_name,  presence: true, if: 'brand_id.nil?'
  validates :supplier_id, presence: true
  validates :current_quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :quantity_ordered, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_save :set_brand, if: 'brand_name.present?'

  private 
  
  def set_brand
    self.brand_id = Brand.find_or_create_by(name: brand_name).id
  end
end