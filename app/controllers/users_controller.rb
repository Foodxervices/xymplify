class UsersController < ApplicationController
  load_and_authorize_resource 

  def index
    @user_filter = UserFilter.new(user_filter_params)
    @users = @user_filter.result.paginate(:page => params[:page])
  end

  def show; end

  def new; end

  def create
    if @user.save
      redirect_to users_url, notice: 'User has been created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      redirect_to users_url, notice: 'User has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = 'User has been deleted.'
    else
      flash[:notice] = @user.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  private 

  def user_filter_params
    user_filter = ActionController::Parameters.new(params[:user_filter])
    user_filter.permit(
      :keyword,
    )
  end

  def user_params
    data = params.require(:user).permit(
      :name,
      :email,
      :avatar,
      :password,
      :password_confirmation,
      :type
    )
    if data[:password].blank?
      data.delete(:password)
      data.delete(:password_confirmation) 
    end
    data
  end
end