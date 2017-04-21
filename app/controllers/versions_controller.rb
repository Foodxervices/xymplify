class VersionsController < AdminController
  load_and_authorize_resource :version, only: [:show]
  before_action :detect_format, only: [:index]

  def index
    if current_kitchen&.id
      authorize! :history, current_kitchen
      @versions = Version.by_kitchen(current_kitchen.id)
    else
      authorize! :history, current_restaurant
      @versions = Version.by_restaurant(current_restaurant.id)
    end

    @version_filter = VersionFilter.new(@versions, version_filter_params)
    @versions = @version_filter.result
                              .includes(:user, :item, inventory: :food_item, order_gst: :order, order_item: :order)

    respond_to do |format|
      format.html do
        @versions = @versions.paginate(:page => params[:activity_page], :per_page => 50)
      end

      format.xlsx do
        filename = "#{@version_filter.start_date} - #{@version_filter.end_date}"
        render xlsx: "index", filename: filename
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

  def detect_format
    request.format = "xlsx" if params[:commit] == 'Export'
  end
end