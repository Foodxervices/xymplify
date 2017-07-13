class DishFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(dishes, attributes = {})
    @dishes = dishes
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    @dishes
  end

  def persisted?
    false
  end
end