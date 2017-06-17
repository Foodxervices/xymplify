class SupplierFilter
  include ActiveModel::Model
  attr_accessor :keyword, :restaurant_id

  def initialize(suppliers, attributes = {})
    @suppliers = suppliers
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    @suppliers = @suppliers.where("
                            suppliers.name                 ILIKE :keyword OR
                            suppliers.address              ILIKE :keyword OR
                            suppliers.country              ILIKE :keyword OR
                            suppliers.contact              ILIKE :keyword OR
                            suppliers.telephone            ILIKE :keyword OR
                            suppliers.email                ILIKE :keyword OR
                            suppliers.bank_account_number  ILIKE :keyword OR
                            suppliers.currency             ILIKE :keyword
                          ", keyword: "%#{keyword}%") if keyword.present?

    @suppliers = @suppliers.where(restaurant_id: restaurant_id) if restaurant_id.present?
    @suppliers
  end

  def persisted?
    false
  end
end