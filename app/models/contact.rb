class Contact < ActiveRecord::Base
  validates :name,          presence: true
  validates :email,         presence: true, email: true
  validates :designation,   presence: true
  validates :organisation,  presence: true
  validates :your_query,    presence: true
end