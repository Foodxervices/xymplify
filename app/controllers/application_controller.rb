class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource

  before_action :authenticate_user!

  protected

  def layout_by_resource
    devise_controller? ? 'devise' : 'main'
  end
end
