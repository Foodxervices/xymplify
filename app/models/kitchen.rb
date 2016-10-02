class Kitchen < ActiveRecord::Base
  belongs_to :restaurant
  has_many :food_items, dependent: :destroy
  has_and_belongs_to_many :user_roles

  has_one :bank, as: :bankable, inverse_of: :bankable

  validates_associated :restaurant

  validates :name, presence: true

  accepts_nested_attributes_for :bank
end