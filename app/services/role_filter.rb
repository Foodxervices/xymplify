class RoleFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    roles = Role.all
    roles =  roles.joins("LEFT JOIN users ON roles.user_id = users.id")
                  .joins("LEFT JOIN restaurants ON roles.restaurant_id = restaurants.id")
                  .where("
                          roles.name        ILIKE :keyword OR
                          users.name        ILIKE :keyword OR
                          restaurants.name  ILIKE :keyword
                        ", keyword: "%#{keyword}%") if keyword.present?
    roles
  end

  def persisted?
    false
  end
end