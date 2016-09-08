class SupplierFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    suppliers = Supplier.all
    suppliers = suppliers.where("suppliers.name ILIKE :keyword", keyword: "%#{keyword}%") if keyword.present?
    suppliers
  end

  def persisted?
    false
  end
end