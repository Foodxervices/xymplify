class Restaurant < ActiveRecord::Base
  extend Enumerize

  has_paper_trail ignore: [:receive_email]
  acts_as_paranoid

  serialize :receive_email, Array
  enumerize :receive_email, in: [
    :after_updated, :after_placed, :after_accepted, :after_declined, :after_cancelled, :after_delivered, :after_paid
  ], multiple: true, default: [:after_updated, :after_placed, :after_accepted, :after_declined, :after_cancelled, :after_delivered, :after_paid]

  has_many :user_roles
  has_many :users, -> { uniq }, :through => :user_roles
  has_many :orders, through: :kitchens
  has_many :food_items
  has_many :order_items, through: :orders, source: :items
  has_many :messages
  has_many :inventories
  has_many :kitchens
  has_many :suppliers

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