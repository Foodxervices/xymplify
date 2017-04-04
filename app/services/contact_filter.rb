class ContactFilter
  include ActiveModel::Model
  attr_accessor :keyword

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def result
    contacts =  Contact.uniq
    contacts =  contacts.where("
                        contacts.name       ILIKE :keyword OR
                        contacts.email      ILIKE :keyword
                      ", keyword: "%#{keyword}%") if keyword.present?
    contacts
  end

  def persisted?
    false
  end
end