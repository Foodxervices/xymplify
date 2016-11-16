class AddCutOffTimingToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :cut_off_timing, :integer
  end
end
