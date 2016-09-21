class UserRoleFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    user_roles =  UserRole.all
    user_roles =  user_roles.joins("LEFT JOIN users ON user_roles.user_id = users.id")
                            .joins("LEFT JOIN restaurants ON user_roles.restaurant_id = restaurants.id")
                            .joins("LEFT JOIN roles ON user_roles.role_id = roles.id")
                            .where("
                                    roles.name        ILIKE :keyword OR
                                    users.name        ILIKE :keyword OR
                                    restaurants.name  ILIKE :keyword
                                  ", keyword: "%#{keyword}%") if keyword.present?
    user_roles
  end

  def persisted?
    false
  end
end