class RolesController < ApplicationController
  load_and_authorize_resource

  def index
    @role_filter = RoleFilter.new(role_filter_params)
    @roles = @role_filter.result.includes(:user, :restaurant).paginate(:page => params[:page])
  end

  def show; end

  def new; end

  def create
    if @role.save
      redirect_to roles_url, notice: 'Role has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @role.update_attributes(role_params)
      redirect_to roles_url, notice: 'Role has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @role.destroy
      flash[:notice] = 'Role has been deleted.'
    else
      flash[:notice] = @role.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  private 

  def role_filter_params
    role_filter = ActionController::Parameters.new(params[:role_filter])
    role_filter.permit(
      :keyword,
    )
  end

  def role_params
    params.require(:role).permit(
      :name,
      :user_id,
      :restaurant_id,
      permission_ids: []
    )
  end
end