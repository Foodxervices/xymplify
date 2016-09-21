class RoleFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    roles = Role.all
    roles = roles.where("name ILIKE :keyword", keyword: "%#{keyword}%") if keyword.present?
    roles
  end

  def persisted?
    false
  end
end