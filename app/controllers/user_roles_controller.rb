class UserRolesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :user_role, :through => :restaurant, :shallow => true

  def index
    @user_role_filter = UserRoleFilter.new(@user_roles, user_role_filter_params)
    @user_roles = @user_role_filter.result
                                   .includes(:user, :role, :kitchens).paginate(:page => params[:page])
  end

  def show; end

  def new; end

  def create
    if @user_role.save
      redirect_to [@restaurant, :user_roles], notice: 'User Role has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user_role.update_attributes(user_role_params)
      redirect_to [@user_role.restaurant, :user_roles], notice: 'User Role has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @user_role.destroy
      flash[:notice] = 'User Role has been deleted.'
    else
      flash[:notice] = @user_role.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  private 

  def user_role_filter_params
    user_role_filter = ActionController::Parameters.new(params[:user_role_filter])
    user_role_filter.permit(
      :keyword,
    )
  end

  def user_role_params
    data = params.require(:user_role).permit(
      :user_id,
      :role_id,
      kitchen_ids: []
    )
    data[:restaurant_id] = current_restaurant.id
    data
  end
end