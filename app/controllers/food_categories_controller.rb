class FoodCategoriesController < AdminController
  before_action :clear_restaurant_sessions, only: [:index]
  load_and_authorize_resource :category, parent: false

  def index
    @category_filter = CategoryFilter.new(@categories, category_filter_params)
    @categories = @category_filter.result
                                 .order(:priority, :name)
  end

  def new; end

  def create
    if @category.save
      redirect_to :back, notice: 'Category has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update_attributes(category_params)
      redirect_to :back, notice: 'Category has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = 'Category has been deleted.'
    else
      flash[:notice] = @category.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  def update_priority
    categories = {}
    params[:ids].each_with_index do |id, index|
      categories[id] = {priority: index + 1}
    end

    Category.update(categories.keys, categories.values)
    render nothing: true
  end

  private 

  def category_filter_params
    category_filter = ActionController::Parameters.new(params[:category_filter])
    category_filter.permit(
      :keyword,
    )
  end

  def category_params
    params.require(:category).permit(:name)
  end
end