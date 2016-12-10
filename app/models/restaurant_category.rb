class RestaurantCategory < ActiveRecord::Base
  acts_as_taggable

  belongs_to :restaurant
  belongs_to :category
  
  has_many :food_items
end