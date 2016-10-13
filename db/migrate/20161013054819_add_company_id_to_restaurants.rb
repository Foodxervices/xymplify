class AddCompanyIdToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :company_registration_no, :string
  end
end
