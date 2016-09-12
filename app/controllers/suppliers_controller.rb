class SuppliersController < ApplicationController
  load_and_authorize_resource 

  def index
    @supplier_filter = SupplierFilter.new(supplier_filter_params)
    @suppliers = @supplier_filter.result.paginate(:page => params[:page])
  end

  def show; end

  def new; end

  def create
    if @supplier.save
      redirect_to suppliers_url, notice: 'Supplier has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @supplier.update_attributes(supplier_params)
      redirect_to suppliers_url, notice: 'Supplier has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @supplier.destroy
      flash[:notice] = 'Supplier has been deleted.'
    else
      flash[:notice] = @supplier.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  private 

  def supplier_filter_params
    supplier_filter = ActionController::Parameters.new(params[:supplier_filter])
    supplier_filter.permit(
      :keyword,
    )
  end

  def supplier_params
    params.require(:supplier).permit(
      :name,
      :country,
      :contact,
      :telephone,
      :email
    )
  end
end