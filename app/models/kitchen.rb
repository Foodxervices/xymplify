class Kitchen < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :restaurant

  has_many :orders,      dependent: :restrict_with_error
  has_many :inventories, dependent: :restrict_with_error
  has_many :messages,    dependent: :destroy
  has_many :food_items_kitchens, dependent: :destroy
  has_many :food_items, through: :food_items_kitchens

  has_and_belongs_to_many :user_roles

  validates :name,    presence: true
  validates :address, presence: true
  validates :phone,   presence: true

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def get_role(user)
    UserRole.joins('LEFT JOIN kitchens_user_roles ku ON ku.user_role_id = user_roles.id')
            .where('user_id = ? AND restaurant_id = ?', user.id, restaurant_id)
            .where('(kitchens_count = 0 OR ku.kitchen_id = ?)', id).first&.role
  end

  def alert_updated_at
    key = "alert_kitchen_#{id}_updated_at"
    $redis.get(key).to_date
  end

  def redis(key)
    $redis.get(redis_key(key))
  end

  def set_redis(key, value)
    $redis.set(redis_key(key), value)
  end

  def redis_key(str)
    "kitchen:#{id}:#{str}"
  end
end