class AddBankFieldsToKitchens < ActiveRecord::Migration
  def change
    add_column :kitchens, :bank_name, :string
    add_column :kitchens, :bank_address, :string
    add_column :kitchens, :bank_swift_code, :string
    add_column :kitchens, :bank_account_name, :string
    add_column :kitchens, :bank_account_number, :string
  end
end
