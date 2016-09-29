class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name
      t.string :address
      t.string :swift_code
      t.string :account_name
      t.string :account_number
      t.references :bankable, polymorphic: true, index: true
    end
  end
end
