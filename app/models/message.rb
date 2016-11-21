class Message < ActiveRecord::Base
  belongs_to :restaurant

  validates :restaurant_id, presence: true
  validates :title,         presence: true
end