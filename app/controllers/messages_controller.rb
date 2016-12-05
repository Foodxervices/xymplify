class MessagesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :message, :through => :restaurant, :shallow => true

  def show; end

  def new
    @message.kitchen_id = params[:kitchen_id]
    load_mention_list
  end

  def create
    if @message.save
      redirect_to :back, notice: 'Message has been created.'
    else
      load_mention_list
      render :new
    end
  end

  def edit
    load_mention_list
  end

  def update
    if @message.update_attributes(message_params)
      redirect_to :back, notice: 'Message has been updated.'
    else
      render :edit
    end
  end

  def destroy
    if @message.destroy
      flash[:notice] = 'Message has been deleted.'
    else
      flash[:notice] = @message.errors.full_messages.join("<br />")
    end

    redirect_to :back
  end

  protected

  def load_mention_list
    @mention_list = []
    
    @restaurant.suppliers.accessible_by(current_ability).each do |supplier|
      @mention_list << {
        id:     "supplier#{supplier.id}",
        name:   supplier.name,
        avatar: ActionController::Base.helpers.asset_url(supplier.logo.url(:thumb)),
        type:   :contact
      }
    end

    @restaurant.users.each do |user|
      @mention_list << {
        id:     "user#{user.id}",
        name:   user.name,
        avatar: ActionController::Base.helpers.asset_url(user.avatar.url(:thumb)),
        type:   :contact
      }
    end
  end

  def message_params
    data = params.require(:message).permit(:content, :kitchen_id)
    data[:kitchen_id] = Kitchen.accessible_by(current_ability).where(restaurant_id: @restaurant.id).find(data[:kitchen_id]).id if data[:kitchen_id].present?
    data
  end
end