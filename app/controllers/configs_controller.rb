class ConfigsController < AdminController
  before_action :clear_restaurant_sessions, only: [:index]
  load_and_authorize_resource

  def index; end 

  def edit; end

  def update
    if @config.update_attributes(config_params)
      redirect_to :back, notice: 'Config has been updated.'
    else
      render :edit
    end
  end

  private 

  def config_params
    params.require(:config).permit(
      :value
    )
  end
end