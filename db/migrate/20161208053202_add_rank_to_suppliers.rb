class AddRankToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :rank, :integer, index: true, default: 100
  end
end
