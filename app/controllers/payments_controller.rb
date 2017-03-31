class PaymentsController < AdminController
  before_action :load_and_authorize_payment, only: [:edit, :update]

  def index
    @suppliers = current_restaurant.suppliers.accessible_by(current_ability)
    @supplier_filter = SupplierFilter.new(@suppliers, supplier_filter_params)
    @suppliers = @supplier_filter.result
                                 .order(:priority, :name)
  end

  def edit; end

  def update
    paid_amount_was = @order.paid_amount

    if @order.update_attributes(payment_params)
      if paid_amount_was != @order.paid_amount
        paid = @order.paid_amount - paid_amount_was
        PaymentMailerWorker.perform_async(@order.id, paid)
      end
      redirect_to :back, notice: 'Payment has been updated.'
    else
      render :edit
    end
  end

  private

  def supplier_filter_params
    supplier_filter = ActionController::Parameters.new(params[:supplier_filter])
    supplier_filter.permit(
      :keyword,
    )
  end

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