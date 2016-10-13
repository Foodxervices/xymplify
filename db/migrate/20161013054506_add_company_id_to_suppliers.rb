class AddCompanyIdToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :company_registration_no, :string
  end
end
