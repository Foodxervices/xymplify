class Supplier < ActiveRecord::Base
  has_many :food_items

  validates :name,        presence: true

  def country_name
    ISO3166::Country[country]
  end
end
