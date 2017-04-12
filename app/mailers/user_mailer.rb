class UserMailer < ActionMailer::Base
  default template_path: 'mailers/user'

  def send_new_password_instructions(user, new_password)
    @user = user
    @new_password = new_password

    mail(
      to: @user.email,
      subject: "[XIMPLIFY] Sign Up Successfully!"
    )
  end
end
