class AddPaidAmountToOrders < ActiveRecord::Migration
  def change
    add_monetize :orders, :paid_amount, default: 0
  end
end
