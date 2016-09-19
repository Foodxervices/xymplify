class AddBankAccountNumberToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :bank_account_number, :string
  end
end
