class CreateRolesPermissions < ActiveRecord::Migration
  def change
    create_table :permissions_roles do |t|
      t.belongs_to :role, index: true
      t.belongs_to :permission, index: true
    end
  end
end
