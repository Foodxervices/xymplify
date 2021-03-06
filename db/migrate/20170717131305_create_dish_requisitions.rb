class CreateDishRequisitions < ActiveRecord::Migration
  def change
    create_table :dish_requisitions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :kitchen, index: true
      t.timestamps
    end

    create_table :dish_requisition_items do |t|
      t.belongs_to :dish_requisition, index: true
      t.belongs_to :dish, index: true
      t.decimal :quantity, precision: 8, scale: 2, default: 0.0
    end
  end
end
