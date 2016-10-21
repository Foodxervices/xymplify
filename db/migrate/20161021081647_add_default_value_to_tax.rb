class AddDefaultValueToTax < ActiveRecord::Migration
  def change
    change_column_default :order_gsts, :name, 'GST'
  end
end
