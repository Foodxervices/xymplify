class AddCcEmails < ActiveRecord::Migration
  def change
    add_column :suppliers, :cc_emails, :string, default: ''
  end
end
