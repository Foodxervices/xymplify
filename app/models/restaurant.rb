class Restaurant < ActiveRecord::Base
  has_many :chickens

  validates :name,   presence: true
  validates :email,  email: true

  accepts_nested_attributes_for :chickens, reject_if: :all_blank
end