class UserMailer < ActionMailer::Base
  default template_path: 'mailers/user'

  def send_new_password_instructions(user, token)
    @user = user
    @reset_password_url = Rails.application.routes.url_helpers.edit_user_password_url(reset_password_token: token, host: Rails.application.secrets.host)

    mail(
      to: @user.email,
      subject: "[XYMPLIFY] Sign Up Successfully!"
    )
  end
end
