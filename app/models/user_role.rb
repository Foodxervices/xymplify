class UserRole < ActiveRecord::Base
  has_paper_trail

  extend Enumerize

  belongs_to :role
  belongs_to :user
  belongs_to :restaurant

  has_and_belongs_to_many :kitchens, :counter_cache => true
  
  validates :role_id,       presence: true
  validates :restaurant_id, presence: true
  validates :user_id,       presence: true, uniqueness: {scope: [:role_id, :restaurant_id]}

  def name
    "#{user&.name}'s Role"
  end
end