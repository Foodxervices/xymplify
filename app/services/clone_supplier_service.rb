class CloneSupplierService
  include ActiveModel::Model
  attr_accessor :source_id
  attr_accessor :user_id
  attr_accessor :kitchen_ids

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def save
    CloneSupplierWorker.perform_async(user_id, source_id, kitchen_ids)
  end

  def persisted?
    false
  end
end