class ChangeDefaultValueForOrderGsts < ActiveRecord::Migration
  def change
    change_column_default :order_gsts, :percent, 7
  end
end
