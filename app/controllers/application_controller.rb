class ApplicationController < ActionController::Base
  include PopupHelper
  protect_from_forgery with: :exception
  layout :layout_by_resource

  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  protected

  def layout_by_resource
    devise_controller? ? 'devise' : 'main'
  end

  def authenticate_user!
    if request.format.symbol != :js
      super
    else
      if !user_signed_in?
        open_message(message: 'You need to sign in or sign up before continuing.')
      else
        return true 
      end
    end
  end
end
