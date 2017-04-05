class PaymentHistory < ActiveRecord::Base
  monetize :pay_amount_cents
  monetize :outstanding_amount_cents

  belongs_to :order
end