class Currency
  def self.format(amount, code)
    ActionController::Base.helpers.humanized_money_with_symbol(Money.from_amount(amount, code))
  end
end