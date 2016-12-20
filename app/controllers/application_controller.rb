class ApplicationController < ActionController::Base
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
    return if @restaurant.try(:new_record?)
    @current_restaurant ||= (@restaurant || current_kitchen.try(:restaurant) || resource.try(:restaurant))
  end

  def current_orders
    @current_orders ||= Order.where(user_id: current_user.id, kitchen_id: current_kitchen.id, status: [:wip, :confirmed]).order(:supplier_id)
  end

  def current_confirmed_orders
    @confirmed_orders ||= current_orders.where(status: :confirmed)
  end

  def current_kitchen
    return if @kitchen.try(:new_record?)
    @current_kitchen ||= (@kitchen || resource.try(:kitchen))

    if @current_kitchen.nil? && params[:kitchen_id]
      @current_kitchen ||= Kitchen.accessible_by(current_ability).find(params[:kitchen_id])
    end

    @current_kitchen
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
end
