class User < ActiveRecord::Base
  extend Enumerize

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  enumerize :type,    in: [:Admin], scope: true

  has_many :food_items
end
