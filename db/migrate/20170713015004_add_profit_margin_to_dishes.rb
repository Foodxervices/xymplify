class AddProfitMarginToDishes < ActiveRecord::Migration
  def change
    add_monetize :dishes, :profit_margin
  end
end
