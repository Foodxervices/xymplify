class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|
      t.belongs_to :food_item, index: true 
      t.string :unit
      t.float :rate
    end
  end
end
