class Restaurant < ActiveRecord::Base
  validates :name,   presence: true
  validates :email,  email: true
end