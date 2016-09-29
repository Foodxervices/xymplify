class AddBankFieldsToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :bank_name, :string
    add_column :suppliers, :bank_address, :string
    add_column :suppliers, :bank_swift_code, :string
    add_column :suppliers, :bank_account_name, :string
    add_column :suppliers, :bank_account_number, :string
  end
end
