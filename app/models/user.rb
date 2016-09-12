class User < ActiveRecord::Base
  extend Enumerize

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :food_items

  validates :type, presence: true

  enumerize :type, in: [:Admin], scope: true
end
