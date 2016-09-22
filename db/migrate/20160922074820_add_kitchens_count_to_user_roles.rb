class AddKitchensCountToUserRoles < ActiveRecord::Migration
  def self.up
    add_column :user_roles, :kitchens_count, :integer, :default => 0

    UserRole.reset_column_information
    UserRole.all.each do |r|
      UserRole.update_counters r.id, :kitchens_count => r.kitchens.length
    end
  end

  def self.down
    remove_column :user_roles, :kitchens_count
  end
end
