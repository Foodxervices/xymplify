class Seen < ActiveRecord::Base
  validates :user_id,       presence: true
  validates :restaurant_id, presence: true

  belongs_to :user
  belongs_to :restaurant
end