class AnalyticsController < AdminController
  load_and_authorize_resource :through => :current_kitchen

  def index
    @analytics = current_kitchen.analytics
                               .select(:start_period, :current_quantity, :quantity_ordered)
                               .order(:start_period)
  end
end