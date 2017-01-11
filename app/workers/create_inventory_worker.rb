class CreateInventoryWorker
  include Sidekiq::Worker

  def perform(food_item_id, kitchen_id)
    kitchen   = Kitchen.find(kitchen_id)

    Inventory.where(food_item_id: food_item_id, kitchen_id: kitchen_id, restaurant_id: kitchen.restaurant_id).first_or_create
  end
end