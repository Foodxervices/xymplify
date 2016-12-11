class Category < ActiveRecord::Base
  has_many :food_items,            :dependent => :restrict_with_error
  has_many :restaurant_categories, :dependent => :restrict_with_error
  has_many :order_items,           :dependent => :restrict_with_error

  validates :name, presence: true
end