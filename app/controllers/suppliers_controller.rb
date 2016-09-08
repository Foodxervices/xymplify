class SuppliersController < ApplicationController
  load_and_authorize_resource 

  def index
    @suppliers = Supplier.paginate(:page => params[:page])
  end

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

  private 

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