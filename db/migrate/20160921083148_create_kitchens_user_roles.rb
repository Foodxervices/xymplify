class CreateKitchensUserRoles < ActiveRecord::Migration
  def change
    create_table :kitchens_user_roles do |t|
      t.belongs_to :kitchen, index: true
      t.belongs_to :user_role, index: true
    end
  end
end
