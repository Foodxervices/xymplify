class DishRequisitionItem < ActiveRecord::Base
  monetize :unit_price_cents

  belongs_to :dish, -> { with_deleted }
  belongs_to :dish_requisition, inverse_of: :items

  after_validation :validate_inventory
  before_create :set_unit_price
  before_create :update_inventory

  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 9999999999 }
  validates :quantity, presence: true, numericality: { greater_than: 0, less_than: 99999999 }

  def self.unit_price
    all.map(&:unit_price).inject(0, :+)
  end

  def total_price
    unit_price * quantity
  end

  def self.total_price
    all.map(&:total_price).inject(0, :+)
  end

  private

  def validate_inventory
    return if dish.nil?
    
    dish.items.each do |i|
      inventory = Inventory.where(food_item_id: i.food_item_id, kitchen: dish_requisition.kitchen_id).first
      return errors.add(:dish_id, "#{i.food_item&.name} Not Found") if inventory.nil?
      return errors.add(:dish_id, "No more food #{i.food_item&.name} in inventory") if inventory.current_quantity == 0
      return errors.add(:dish_id, "#{i.food_item&.name}: Not enough food in inventory") if inventory.current_quantity < i.quantity * quantity
    end
  end

  def set_unit_price
    self.unit_price = dish.price
  end

  def update_inventory
    return if dish.nil?

    dish.items.each do |i|
      inventory = Inventory.where(food_item_id: i.food_item_id, kitchen: dish_requisition.kitchen_id).first

      inventory.with_lock do
        inventory.current_quantity = inventory.current_quantity - i.quantity * quantity
        inventory.save!
      end
    end
  end
end