class Role < ActiveRecord::Base
  extend Enumerize

  belongs_to :user
  belongs_to :restaurant
  
  validates_associated :restaurant, :user

  validates :name,          presence: true
  validates :user_id,       presence: true
  validates :restaurant_id, presence: true

  enumerize :name, in: ['Owner', 'KitchenManager'], scope: true
end