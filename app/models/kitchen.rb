class Kitchen < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :restaurant
  has_and_belongs_to_many :food_items
  has_and_belongs_to_many :user_roles
  has_many :orders

  has_one :bank, as: :bankable, inverse_of: :bankable

  validates_associated :restaurant

  validates :name,    presence: true
  validates :address, presence: true
  validates :phone,   presence: true

  accepts_nested_attributes_for :bank

  def to_param
    "#{id}-#{name.parameterize}"
  end
end