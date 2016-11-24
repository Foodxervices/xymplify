class Message < ActiveRecord::Base
  belongs_to :restaurant

  validates :restaurant_id, presence: true
  validates :content,       presence: true
end