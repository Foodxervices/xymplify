class UserFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    users = User.uniq
    users = users.where("users.email ILIKE :keyword", keyword: "%#{keyword}%") if keyword.present?
    users
  end

  def persisted?
    false
  end
end