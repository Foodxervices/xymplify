class Supplier < ActiveRecord::Base
  has_many :food_items

  validates :name,        presence: true
end
