class RemoveTitleFromAlerts < ActiveRecord::Migration
  def change
    remove_column :alerts, :title, :string
  end
end
