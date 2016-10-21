class AddStatusUpdatedAt < ActiveRecord::Migration
  def change
    add_column :orders, :status_updated_at, :datetime
  end
end
