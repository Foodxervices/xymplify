class RemoveBankAccountNumber < ActiveRecord::Migration
  def change
    remove_column :suppliers, :bank_account_number, :string
  end
end
