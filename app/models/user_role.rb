class UserRole < ActiveRecord::Base
  extend Enumerize

  belongs_to :role
  belongs_to :user
  belongs_to :restaurant
  has_and_belongs_to_many :kitchens, :counter_cache => true

  validates_associated :restaurant, :user, :role
  
  validates :role_id,       presence: true
  validates :user_id,       presence: true, uniqueness: {scope: :role_id}
  validates :restaurant_id, presence: true
end