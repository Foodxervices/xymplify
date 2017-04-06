class SuppliersController < AdminController
  load_and_authorize_resource :supplier, :through => :current_restaurant

  before_action :init_processing_cut_off, only: [:new, :edit]

  def index
    @supplier_filter = SupplierFilter.new(@suppliers, supplier_filter_params)
    @suppliers = @supplier_filter.result
                                 .order(:priority, :name)
  end

  def show; end

  def new
    @supplier.kitchen_ids = current_restaurant.kitchens.pluck(:id)
  end

  def create
    if @supplier.save
      redirect_to :suppliers, notice: 'Supplier has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @supplier.update_attributes(supplier_params)
      redirect_to :suppliers, notice: 'Supplier has been updated.'
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

  def update_priority
    suppliers = {}
    params[:ids].each_with_index do |id, index|
      suppliers[id] = {priority: index + 1}
    end

    Supplier.update(suppliers.keys, suppliers.values)
    render nothing: true
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
      :min_order_price,
      :max_order_price,
      :processing_cut_off,
      :block_delivery_dates,
      kitchen_ids: [],
      delivery_days: []
    )
    data[:kitchen_ids] = current_restaurant.kitchens.where(id: data[:kitchen_ids]).pluck(:id)
    data[:restaurant_id] = current_restaurant.id
    data
  end

  def init_processing_cut_off
    @supplier.processing_cut_off ||= Time.now.utc.change(hour: 18, min: 0)
  end
end