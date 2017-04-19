class ProfilesController < AdminController
  before_action :authenticate_user!

  def edit; end

  def update
    if current_user.update_with_password(profile_params)
      redirect_to :back, notice: 'Profile has been updated.'
    else
      render :edit
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
      :current_password,
      :receive_email
    )
    if data[:password].blank?
      data.delete(:password)
      data.delete(:password_confirmation)
    end
    data
  end
end