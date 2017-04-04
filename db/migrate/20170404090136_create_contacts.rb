class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :designation
      t.string :organisation
      t.text :your_query
    end
  end
end
