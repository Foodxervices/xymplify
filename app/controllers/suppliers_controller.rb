class SuppliersController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :supplier, :through => :restaurant, :shallow => true

  def index
    @supplier_filter = SupplierFilter.new(@suppliers, supplier_filter_params)
    @suppliers = @supplier_filter.result
                                 .paginate(:page => params[:page])
  end

  def show; end

  def new; end

  def create
    if @supplier.save
      redirect_to [@restaurant, :suppliers], notice: 'Supplier has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @supplier.update_attributes(supplier_params)
      redirect_to [@supplier.restaurant, :suppliers], notice: 'Supplier has been updated.'
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
    data = params.require(:supplier).permit(
      :name,
      :address,
      :country,
      :contact,
      :telephone,
      :email,
      :currency,
      :company_registration_no,
      :logo,
      :bank_name,
      :bank_address,
      :bank_swift_code,
      :bank_account_name,
      :bank_account_number,
      :cut_off_timing
    )
    data[:rank] = params[:supplier][:rank] if current_user.kind_of?(Admin)
    data
  end
end