class PaymentsController < ApplicationController
  before_action :load_and_authorize_payment

  def edit; end

  def update
    if @order.update_attributes(payment_params)
      redirect_to :back, notice: 'Payment has been updated.'
    else
      render :edit
    end
  end

  private

  def payment_params
    params.require(:order).permit(
      :paid_amount
    )
  end

  def load_and_authorize_payment
    @order = Order.find(params[:id])
    authorize! :pay, @order
  end
end