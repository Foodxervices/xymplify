class ChangeDefaultNameOfGst < ActiveRecord::Migration
  def change
    change_column_default :order_gsts, :name, ""
  end
end
