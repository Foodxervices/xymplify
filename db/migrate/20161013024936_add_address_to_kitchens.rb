class AddAddressToKitchens < ActiveRecord::Migration
  def change
    add_column :kitchens, :address, :string
  end
end
