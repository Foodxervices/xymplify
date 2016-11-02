class UpdateShippedToDelivered < ActiveRecord::Migration
  def change
    Order.where(status: :shipped).update_all(status: :delivered)
  end
end
