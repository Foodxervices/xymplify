class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  
  validates_associated :restaurant, :user

  validates :name,          presence: true
  validates :user_id,       presence: true
  validates :restaurant_id, presence: true
end