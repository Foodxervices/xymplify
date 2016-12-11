class CategoryFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(categories, attributes = {})
    @categories = categories
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    @categories = @categories.where("categories.name ILIKE :keyword", keyword: "%#{keyword}%") if keyword.present?
    @categories
  end

  def persisted?
    false
  end
end