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
  has_many :analytics
  has_many :food_items
  has_many :order_items, through: :orders, source: :items
  has_many :messages
  has_many :inventories
  has_many :kitchens
  has_many :suppliers
  has_many :dishes
  has_many :requisitions, through: :kitchens
  has_many :dish_requisitions, through: :kitchens

  validates :name,        presence: true
  validates :currency,    presence: true
  validates :email,  email: true

  has_attached_file :logo, styles: { thumb: "148x80>", medium: "370x200>" }
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  accepts_nested_attributes_for :kitchens, reject_if: :all_blank

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def in_block_delivery_dates?(date)
    block_delivery_dates.present? && block_delivery_dates.split(',').each do |block_date|
      return true if block_date.to_date.beginning_of_day == date.beginning_of_day
    end

    false
  end
end