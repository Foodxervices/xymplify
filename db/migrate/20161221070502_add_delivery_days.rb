class AddDeliveryDays < ActiveRecord::Migration
  def change
    add_column :suppliers, :delivery_days, :string 
    remove_column :suppliers, :cut_off_timing
  end
end
