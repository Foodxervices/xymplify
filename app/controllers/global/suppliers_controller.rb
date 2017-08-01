class Global::SuppliersController < AdminController
  helper_method :sort_column, :sort_direction
  before_action :authorize
  before_action :clear_restaurant_sessions

  def index
    @supplier_filter = SupplierFilter.new(Supplier.all, supplier_filter_params)
    @suppliers = @supplier_filter.result
                                 .paginate(:page => params[:page])
    @group = {}
    FoodItem.select('MAX(updated_at) as updated_at, supplier_id').group(:supplier_id).where(supplier_id: @suppliers).each do |i|
      @group[i.supplier_id] = i.updated_at
    end
    @suppliers = @suppliers.joins("LEFT JOIN restaurants r ON suppliers.restaurant_id = r.id")
                           .select('suppliers.*, r.name as restaurant_name')
                           .reorder(sort_column + ' ' + sort_direction)
  end

  def clone
    @form = CloneSupplierService.new
  end

  def do_clone
    @form = CloneSupplierService.new(clone_params)

    @form.save

    redirect_to global_suppliers_path
  end

  protected

  def sort_column
    Supplier.column_names
            .push('restaurant_name')
            .include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def supplier_filter_params
    params.require(:supplier_filter).permit(:keyword, :restaurant_id)
  rescue ActionController::ParameterMissing
    {}
  end

  def clone_params
    data = params.require(:clone_supplier_service).permit(kitchen_ids: [])
    data[:supplier_id] = params[:id]
    data[:user_id] = current_user.id
    data
  end

  def authorize
    authorize! :global_suppliers, User
  end
end