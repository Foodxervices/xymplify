class CreateKitchensSuppliers < ActiveRecord::Migration
  def change
    create_table :kitchens_suppliers do |t|
      t.belongs_to :supplier, index: true
      t.belongs_to :kitchen, index: true
    end

    drop_table :supplier_limitations
  end
end
