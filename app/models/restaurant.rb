class Restaurant < ActiveRecord::Base
  has_paper_trail
  
  has_many :suppliers
  has_many :user_roles
  has_many :kitchens, dependent: :destroy
  has_many :orders, through: :kitchens
  has_many :order_items, through: :orders, source: :items
  has_many :food_items, through: :kitchens, dependent: :destroy
  has_many :messages

  validates :name,        presence: true
  validates :currency,    presence: true
  validates :email,  email: true

  has_attached_file :logo, styles: { thumb: "80x80#", medium: "300x300#" }
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

  accepts_nested_attributes_for :kitchens, reject_if: :all_blank

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def alert_updated_at
    key = "alert_restaurant_#{id}_updated_at"
    $redis.get(key).to_date
  end

  def redis(key)
    $redis.get(redis_key(key))
  end

  def set_redis(key, value)
    $redis.set(redis_key(key), value)
  end

  def redis_key(str)
    "restaurant:#{id}:#{str}"
  end
end