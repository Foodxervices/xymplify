class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  has_and_belongs_to_many :permissions
  
  validates_associated :restaurant, :user, :permissions

  validates :name,          presence: true
  validates :user_id,       presence: true
  validates :restaurant_id, presence: true
end