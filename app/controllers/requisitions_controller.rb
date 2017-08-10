class RequisitionsController < AdminController
  before_action :set_session
  load_and_authorize_resource :through => :current_kitchen

  def index
    @requisition_filter = RequisitionFilter.new(@requisitions, requisition_filter_params)
    @requisitions =  @requisition_filter.result
                                    .includes(:items, items: {food_item: :supplier})
                                    .order(updated_at: :desc)
                                    .paginate(:page => params[:page])
  end

  def new
    @requisition.items.new
  end

  def create
    if @requisition.save
      redirect_to :back, notice: 'Requisition has been created.'
    else
      render :new
    end
  end

  private
  def set_session
    session[:kitchen_id] = params[:id].to_i if params[:id]
  end

  def requisition_params
    data = params.require(:requisition).permit(
      items_attributes: [
        :id,
        :food_item_id,
        :quantity,
        :supplier_id,
        :_destroy
      ]
    )
    data[:user_id] = current_user.id
    data
  end

  def requisition_filter_params
    requisition_filter = ActionController::Parameters.new(params[:requisition_filter])
    data = requisition_filter.permit(
      :keyword,
      :supplier_id,
      :date_range
    )
    data
  end
end