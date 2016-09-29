class Bank < ActiveRecord::Base
  belongs_to :bankable, polymorphic: true

  validates_associated :bankable
end