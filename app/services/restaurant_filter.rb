class RestaurantFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    restaurants = Restaurant.all
    restaurants = restaurants.where("
                            restaurants.name              ILIKE :keyword OR
                            restaurants.site_address      ILIKE :keyword OR
                            restaurants.billing_address   ILIKE :keyword OR
                            restaurants.contact_person    ILIKE :keyword OR
                            restaurants.telephone         ILIKE :keyword OR
                            restaurants.email             ILIKE :keyword 
                          ", keyword: "%#{keyword}%") if keyword.present?
    restaurants
  end

  def persisted?
    false
  end
end