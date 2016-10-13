class AddPhoneToKitchens < ActiveRecord::Migration
  def change
    add_column :kitchens, :phone, :string
  end
end
