class Restaurant < ActiveRecord::Base
  has_paper_trail
  
  has_many :suppliers
  has_many :user_roles
  has_many :kitchens, dependent: :destroy
  has_many :orders, through: :kitchens
  has_many :food_items, through: :kitchens, dependent: :destroy

  validates :name,        presence: true
  validates :currency,    presence: true
  validates :email,  email: true

  has_attached_file :logo, styles: { thumb: "80x80#", medium: "300x300#" }
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  accepts_nested_attributes_for :kitchens, reject_if: :all_blank

  def to_param
    "#{id}-#{name.parameterize}"
  end
end