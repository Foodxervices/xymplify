class Restaurant < ActiveRecord::Base
  has_paper_trail
  
  has_many :suppliers
  has_many :user_roles
  has_many :kitchens, dependent: :destroy
  has_many :food_items, through: :kitchens, dependent: :destroy

  validates :name,   presence: true
  validates :email,  email: true

  accepts_nested_attributes_for :kitchens, reject_if: :all_blank

  def to_param
    "#{id}-#{name.parameterize}"
  end
end