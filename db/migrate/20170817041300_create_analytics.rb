class CreateAnalytics < ActiveRecord::Migration
  def change
    create_table :analytics do |t|
      t.belongs_to :restaurant, index: true
      t.belongs_to :kitchen, index: true
      t.decimal :current_quantity, precision: 10, scale: 2, default: 0.0
      t.decimal :quantity_ordered, precision: 10, scale: 2, default: 0.0
      t.date :start_period
    end
  end
end
