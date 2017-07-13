class Dish < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user

  has_many :items, class_name: 'DishItem'

  validates :name, presence: true

  accepts_nested_attributes_for :items, reject_if: :all_blank, allow_destroy: true
end