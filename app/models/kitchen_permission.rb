class KitchenPermission < ActiveRecord::Base
  extend Enumerize

  belongs_to :role
  belongs_to :kitchen

  validates_associated :role, :kitchen
end