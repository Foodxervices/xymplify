class AddCurrencyToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :currency, :string
  end
end
