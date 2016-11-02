class SupplierRequestsController < PublicController
  load_resource :order, :parent => false
  before_action :verify_token

  def mark_as_accepted
    if @order.status.placed?
      ActiveRecord::Base.transaction do
        @order.status = :accepted
        
        flash[:notice] = "#{@order.name} has been accepted." if @order.save
      end
    else
      flash[:notice] = "#{@order.name} was #{@order.status}." 
    end

    redirect_to root_url
  end

  def mark_as_declined
    if @order.status.placed?
      ActiveRecord::Base.transaction do
        @order.status = :declined
        
        flash[:notice] = "#{@order.name} has been declined." if @order.save
      end
    else
      flash[:notice] = "#{@order.name} was #{@order.status}." 
    end

    redirect_to root_url
  end

  private

  def verify_token
    if @order.token != params[:token]
      redirect_to root_url, notice: 'Invalid token'
    end
  end
end