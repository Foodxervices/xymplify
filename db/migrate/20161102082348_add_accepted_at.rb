class AddAcceptedAt < ActiveRecord::Migration
  def change
    add_column :orders, :accepted_at, :datetime
    add_column :orders, :declined_at, :datetime
    add_column :orders, :cancelled_at, :datetime
  end
end
