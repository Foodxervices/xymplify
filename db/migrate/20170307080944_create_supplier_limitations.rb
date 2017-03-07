class CreateSupplierLimitations < ActiveRecord::Migration
  def change
    create_table :supplier_limitations do |t|
      t.belongs_to :supplier, index: true
      t.belongs_to :kitchen, index: true
    end
  end
end
