class SendNewPasswordInstructionsWorker
  include Sidekiq::Worker

  def perform(user_id, new_password)
    user = User.find(user_id)
    Premailer::Rails::Hook.perform(UserMailer.send_new_password_instructions(user, new_password)).deliver_now
  end
end