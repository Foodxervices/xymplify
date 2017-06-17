class Global::SuppliersController < AdminController
  before_action :clear_restaurant_sessions

  def index
    @supplier_filter = SupplierFilter.new(Supplier.all, supplier_filter_params)
    @suppliers = @supplier_filter.result
                                 .includes(:restaurant)
                                 .order(:restaurant_id, :priority, :name)
                                 .paginate(:page => params[:page])
  end

  def clone
    @form = CloneSupplierService.new(source_id: params[:id])
  end

  def do_clone
    @form = CloneSupplierService.new(clone_params)

    @form.save

    redirect_to global_suppliers_path
  end

  protected

  def supplier_filter_params
    params.require(:supplier_filter).permit(:keyword, :restaurant_id)
  rescue ActionController::ParameterMissing
    {}
  end

  def clone_params
    data = params.require(:clone_supplier_service).permit(kitchen_ids: [])
    data[:source_id] = params[:id]
    data[:user_id] = current_user.id
    data
  end
end