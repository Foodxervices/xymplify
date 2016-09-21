class Kitchen < ActiveRecord::Base
  belongs_to :restaurant
  has_many :food_items
  has_and_belongs_to_many :user_roles

  validates_associated :restaurant

  validates :name, presence: true
end