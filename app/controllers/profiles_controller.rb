class ProfilesController < ApplicationController 
  def edit; end

  def update
    @success = current_user.update_with_password(profile_params)
    
    if @success
      flash[:notice] = 'Profile has been updated.'
    end
  end

  private 

  def profile_params
    data = params.require(:profile).permit(
      :name,
      :email,
      :avatar,
      :password,
      :password_confirmation,
      :current_password
    )
    if data[:password].blank?
      data.delete(:password)
      data.delete(:password_confirmation) 
    end
    data
  end
end