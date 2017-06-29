class RequisitionsController < AdminController
  before_action :set_session
  load_and_authorize_resource :through => :current_kitchen

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
        :_destroy
      ]
    )
    data[:user_id] = current_user.id
    data
  end
end