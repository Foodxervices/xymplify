class SupplierFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    suppliers = Supplier.all
    suppliers = suppliers.where("
                            suppliers.name                 ILIKE :keyword OR
                            suppliers.address              ILIKE :keyword OR
                            suppliers.country              ILIKE :keyword OR
                            suppliers.contact              ILIKE :keyword OR
                            suppliers.telephone            ILIKE :keyword OR
                            suppliers.email                ILIKE :keyword OR
                            suppliers.bank_account_number  ILIKE :keyword 
                            suppliers.currency             ILIKE :keyword 
                          ", keyword: "%#{keyword}%") if keyword.present?
    suppliers
  end

  def persisted?
    false
  end
end