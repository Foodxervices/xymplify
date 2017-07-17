class DishesController < AdminController
  load_and_authorize_resource :through => :current_restaurant

  def index
    @dish_filter = DishFilter.new(@dishes, filter_params)
    @dishes = @dish_filter.result.includes(:user, items: {food_item: :supplier}).paginate(:page => params[:page])
  end

  def new
    @dish.items.new
  end

  def create
    if @dish.save
      redirect_to :back, notice: 'Dish has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @dish.update_attributes(dish_params)
      redirect_to :back, notice: 'Dish has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @dish.destroy
      flash[:notice] = 'Dish has been deleted.'
    else
      flash[:notice] = @dish.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  protected

  def dish_params
    data = params.require(:dish).permit(
      :name,
      :profit_margin,
      :profit_margin_currency,
      items_attributes: [
        :id,
        :food_item_id,
        :quantity,
        :_destroy
      ]
    )
    data[:restaurant_id] = current_restaurant.id
    data[:user_id] = current_user.id
    data 
  end

  def filter_params
    dish_filter = ActionController::Parameters.new(params[:dish_filter])

    dish_filter.permit(
      :keyword
    )
  end
end