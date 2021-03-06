class RequisitionItem < ActiveRecord::Base
  attr_accessor :supplier_id
  
  monetize :unit_price_cents

  belongs_to :food_item
  belongs_to :requisition, inverse_of: :items

  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 99999999 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }

  before_create :set_unit_price
  after_validation :validate_inventory
  before_create :update_inventory

  def inventory
    @inventory ||= Inventory.where(food_item_id: food_item_id, kitchen: requisition.kitchen_id).first if requisition
  end

  private

  def validate_inventory
    return errors.add(:food_item_id, "Inventory Not Found") if inventory.nil?
    return errors.add(:quantity, "No more food in inventory") if inventory.current_quantity == 0
    return errors.add(:quantity, "Quantity must be less than or equal to than #{inventory.current_quantity}") if inventory.current_quantity < quantity
  end

  def update_inventory
    inventory.with_lock do
      inventory.current_quantity = inventory.current_quantity - quantity
      inventory.save!
    end
  end

  def set_unit_price
    self.unit_price = food_item.unit_price 
  end
end