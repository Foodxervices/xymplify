class Supplier < ActiveRecord::Base
  default_scope { order(:priority) }
  
  has_paper_trail :ignore => [:priority]
  
  before_destroy :check_for_food_items

  belongs_to :restaurant
  has_many :food_items, :dependent => :restrict_with_error
  has_many :orders,     :dependent => :restrict_with_error

  validates :name,            presence: true
  validates :restaurant_id,   presence: true
  validates :email,           presence: true, email: true
  validates :min_order_price,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }
  validates :max_order_price,  numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }, if: 'max_order_price.present?'
  
  has_attached_file :logo, styles: { thumb: "80x80#", medium: "300x300#" }
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  def country_name
    ISO3166::Country[country]
  end

  def check_for_food_items
    return true if food_items.count == 0
    errors.add :base, "Cannot delete supplier with food items"
    false
  end
end
