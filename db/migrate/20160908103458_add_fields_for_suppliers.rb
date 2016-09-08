class AddFieldsForSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :address, :string
    add_column :suppliers, :country, :string
    add_column :suppliers, :contact, :string
    add_column :suppliers, :telephone, :string
    add_column :suppliers, :email, :string
  end
end
