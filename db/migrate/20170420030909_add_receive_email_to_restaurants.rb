class AddReceiveEmailToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :receive_email, :string
  end
end
