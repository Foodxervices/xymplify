class ChangeColumnDefaultForSuppliersCurrency < ActiveRecord::Migration
  def change
    change_column_default :suppliers, :currency, :SGD
  end
end
