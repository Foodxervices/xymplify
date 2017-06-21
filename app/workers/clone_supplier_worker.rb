class CloneSupplierWorker
  include Sidekiq::Worker

  def perform(user_id, supplier_id, kitchen_ids)
    CloneFoodItemService.new({
      food_items: FoodItem.where(supplier_id: supplier_id),
      supplier_id: supplier_id,
      kitchen_ids: kitchen_ids,
      user_id: user_id
    }).call
  end
end

