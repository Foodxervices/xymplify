class Message < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :kitchen

  validates :restaurant_id, presence: true
  validates :content,       presence: true
end