class AddLogoToSuppliers < ActiveRecord::Migration
  def change
    add_attachment :suppliers, :logo
  end
end
