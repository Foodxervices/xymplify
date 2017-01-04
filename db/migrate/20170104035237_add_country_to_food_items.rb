class AddCountryToFoodItems < ActiveRecord::Migration
  def change
    add_column :food_items, :country_of_origin, :string
  end
end
