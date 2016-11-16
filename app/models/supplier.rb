class Supplier < ActiveRecord::Base
  has_paper_trail
  
  before_destroy :check_for_food_items

  belongs_to :restaurant
  has_many :food_items
  has_many :orders

  validates :name,            presence: true
  validates :restaurant_id,   presence: true
  validates :email,           presence: true, email: true
  
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
