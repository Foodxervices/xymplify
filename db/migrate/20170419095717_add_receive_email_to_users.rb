class AddReceiveEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_email, :boolean, default: false
  end
end
