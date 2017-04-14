class AdminController < ApplicationController
  include PopupHelper
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :js_request?
  layout :layout_by_resource

  helper_method :current_restaurant, :current_kitchen, :current_orders, :alert_count

  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    if !user_signed_in?
      authenticate_user!
    else
      if !js_request?
        redirect_to restaurants_url, alert: exception.message
      else
        open_message(message: exception.message)
      end
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
    return @current_restaurant if @current_restaurant.present?

    session[:restaurant_id] = params[:restaurant_id] if params[:restaurant_id]

    if session[:restaurant_id]
      @current_restaurant ||= Restaurant.accessible_by(current_ability).find_by_id(session[:restaurant_id])

      if !@current_restaurant
        session.delete(:restaurant_id)
        session.delete(:kitchen_id)
        raise CanCan::AccessDenied, 'Invalid access request'
      end
    end

    @current_restaurant
  end

  def current_kitchen
    return @current_kitchen if @current_kitchen.present?

    session[:kitchen_id] = params[:kitchen_id] if params[:kitchen_id]

    if session[:kitchen_id]
      @current_kitchen ||= Kitchen.accessible_by(current_ability).find_by_id(session[:kitchen_id])

      if !@current_kitchen
        session.delete(:kitchen_id)
        redirect_to (current_restaurant || root_path) and return
      else
        session[:restaurant_id] = @current_kitchen.restaurant_id
      end
    end

    @current_kitchen
  end

  def current_orders
    @current_orders ||= Order.where(user_id: current_user.id, kitchen_id: current_kitchen.id, status: [:wip, :confirmed]).order(:supplier_id)
  end

  def current_confirmed_orders
    @confirmed_orders ||= current_orders.where(status: :confirmed)
  end

  def restaurant_owner?
    can?(:manage, current_restaurant)
  end

  def alert_count
    return 0 if current_kitchen.nil?
    return @alert_count if @alert_count.present?
    notification = Notification.new(current_ability, current_kitchen, current_user)
    @alert_count ||= notification.count
  end

  def resource
    eval("@#{controller_name.classify.underscore.to_sym}")
  end

  def disable_bullet
    Bullet.enable = false if Rails.env.development?
  end

  def clear_restaurant_sessions
    session.delete(:restaurant_id)
    session.delete(:kitchen_id)
  end
end
