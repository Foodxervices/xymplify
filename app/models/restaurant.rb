class Restaurant < ActiveRecord::Base
  has_many :kitchens
  has_many :roles

  validates :name,   presence: true
  validates :email,  email: true

  accepts_nested_attributes_for :kitchens, reject_if: :all_blank
end