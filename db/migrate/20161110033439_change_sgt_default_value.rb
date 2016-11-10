class ChangeSgtDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :order_gsts, :percent, 0
  end
end
