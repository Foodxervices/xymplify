class CreateRequisitions < ActiveRecord::Migration
  def change
    create_table :requisitions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :kitchen, index: true
      t.timestamps
    end

    create_table :requisition_items do |t|
      t.belongs_to :requisition, index: true
      t.belongs_to :food_item, index: true
      t.decimal :quantity, precision: 8, scale: 2, default: 0.0
    end
  end
end
