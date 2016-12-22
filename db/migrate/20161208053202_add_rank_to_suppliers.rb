class AddRankToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :rank, :integer, default: 100
  end
end
