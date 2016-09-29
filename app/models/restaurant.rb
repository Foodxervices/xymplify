class Restaurant < ActiveRecord::Base
  has_many :suppliers
  has_many :user_roles
  has_many :kitchens
  has_many :food_items, through: :kitchens

  validates :name,   presence: true
  validates :email,  email: true

  accepts_nested_attributes_for :kitchens, reject_if: :all_blank

  def to_param
    "#{id}-#{name.parameterize}"
  end
end