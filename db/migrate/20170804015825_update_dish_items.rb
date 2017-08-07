class UpdateDishItems < ActiveRecord::Migration
  def change
    add_column :dish_items, :unit, :string
    add_column :dish_items, :unit_rate, :float
  end
end
