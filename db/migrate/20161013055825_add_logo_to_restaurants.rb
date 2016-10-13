class AddLogoToRestaurants < ActiveRecord::Migration
  def change
    add_attachment :restaurants, :logo
  end
end
