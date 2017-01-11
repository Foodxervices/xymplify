class FoodItemsKitchen < ActiveRecord::Base 
  belongs_to :food_item
  belongs_to :kitchen

  after_create :create_inventory

  private
  def create_inventory
    CreateInventoryWorker.perform_async(food_item_id, kitchen_id)
  end
end