class Restaurant < ActiveRecord::Base
  has_paper_trail
  
  has_many :user_roles, dependent: :destroy
  has_many :users, -> { uniq }, :through => :user_roles
  has_many :orders, through: :kitchens
  has_many :food_items, dependent: :destroy
  has_many :order_items, through: :orders, source: :items
  has_many :messages, dependent: :destroy
  has_many :inventories, dependent: :destroy
  has_many :kitchens, dependent: :destroy
  has_many :suppliers, dependent: :destroy

  validates :name,        presence: true
  validates :currency,    presence: true
  validates :email,  email: true

  has_attached_file :logo, styles: { thumb: "148x80#", medium: "370x200#" }
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  accepts_nested_attributes_for :kitchens, reject_if: :all_blank

  def to_param
    "#{id}-#{name.parameterize}"
  end
end