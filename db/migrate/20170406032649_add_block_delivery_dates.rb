class AddBlockDeliveryDates < ActiveRecord::Migration
  def change
    add_column :suppliers, :block_delivery_dates, :string
  end
end
