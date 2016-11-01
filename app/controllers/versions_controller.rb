class VersionsController < ApplicationController
  before_action :disable_bullet, only: [:index]
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :version, :through => :restaurant, :shallow => true, except: [:index]

  def index
    @versions = Version.by_restaurant(@restaurant.id)
    @version_filter = VersionFilter.new(@versions, version_filter_params)
    @versions = @version_filter.result
                              .includes(:user, :item, order_gst: :order, order_item: :order)
                              
    respond_to do |format|
      format.html do
        @versions = @versions.paginate(:page => params[:activity_page], :per_page => 50)
      end

      format.xlsx do 
        render filename: "history.xlsx"
      end
    end
  end 

  def show; end

  protected
  
  def version_filter_params
    version_filter = ActionController::Parameters.new(params[:version_filter])
    version_filter = version_filter.permit(
      :item_type,
      :event,
      :date_range,
      attributes: []
    )
    version_filter[:attributes] = version_filter[:attributes].compact.reject(&:blank?) if version_filter[:attributes].present?
    version_filter
  end
end