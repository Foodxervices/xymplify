class CreatePaymentHistories < ActiveRecord::Migration
  def change
    create_table :payment_histories do |t|
      t.belongs_to :order, index: true
      t.monetize :pay_amount
      t.monetize :outstanding_amount
      t.timestamps
    end
  end
end
