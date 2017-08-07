class RemoveCachePrice < ActiveRecord::Migration
  def change
    remove_column :dishes, :price_without_profit_cents
    remove_column :dishes, :price_without_profit_currency
    remove_column :dishes, :price_cents
    remove_column :dishes, :price_currency
  end
end
