class Kitchen < ActiveRecord::Base
  belongs_to :restaurant

  validates :name, presence: true
end