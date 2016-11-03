class ApplicationController < ActionController::Base
  include PopupHelper
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :js_request?
  layout :layout_by_resource

  helper_method :current_restaurant

  helper_method :current_orders

  helper_method :alert_count

  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    if !user_signed_in?
      authenticate_user!
    else
      redirect_to main_app.root_url, alert: exception.message
    end
  end

  protected

  def layout_by_resource
    devise_controller? ? 'devise' : 'main'
  end

  def authenticate_user!
    if !js_request?
      super
    else
      if !user_signed_in?
        open_message(message: 'You need to sign in or sign up before continuing.')
      else
        return true 
      end
    end
  end

  def js_request?
    request.format.symbol == :js
  end

  def current_restaurant
    return if @restaurant.try(:new_record?)
    @current_restaurant ||= (@restaurant || resource.try(:restaurant))
  end

  def current_orders
    @current_orders ||= Order.where(user_id: current_user.id, kitchen_id: current_restaurant.kitchens, status: :wip)
  end

  def alert_count
    return 0 if current_restaurant.nil?
    return @alert_count if @alert_count.present?
    notification = Notification.new(current_ability, current_restaurant, current_user)
    @alert_count ||= notification.count
  end 

  def resource
    eval("@#{controller_name.classify.underscore.to_sym}")
  end

  def disable_bullet
    Bullet.enable = false if Rails.env.development?
  end
end
