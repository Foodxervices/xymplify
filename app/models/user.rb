class User < ActiveRecord::Base
  extend Enumerize

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :food_items

  validates :name, presence: true
  validates :type, presence: true

  has_attached_file :avatar, styles: { thumb: "80x80#", small: "200x200#" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  enumerize :type, in: [:Admin], scope: true
end
