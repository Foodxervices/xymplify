class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name 
      t.string :site_address
      t.string :billing_address
      t.string :contact_person
      t.string :telephone 
      t.string :email
    end
  end
end
