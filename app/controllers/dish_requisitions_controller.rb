class DishRequisitionsController < AdminController
  before_action :set_session
  load_and_authorize_resource :through => :current_kitchen

  def index
    @dish_requisition_filter = DishRequisitionFilter.new(@dish_requisitions, dish_requisition_filter_params)
    @dish_requisitions =  @dish_requisition_filter.result
                                    .includes(:items, items: :dish)
                                    .order(updated_at: :desc)
                                    .paginate(:page => params[:page])
  end

  def new
    @dish_requisition.items.new
  end

  def create
    if @dish_requisition.save
      redirect_to :back, notice: 'Dish Requisition has been created.'
    else
      render :new
    end
  end

  private
  def set_session
    session[:kitchen_id] = params[:id].to_i if params[:id]
  end

  def dish_requisition_params
    data = params.require(:dish_requisition).permit(
      items_attributes: [
        :id,
        :dish_id,
        :quantity,
        :_destroy
      ]
    )
    data[:user_id] = current_user.id
    data
  end

  def dish_requisition_filter_params
    dish_requisition_filter = ActionController::Parameters.new(params[:dish_requisition_filter])
    data = dish_requisition_filter.permit(
      :keyword,
      :date_range
    )
    data
  end
end