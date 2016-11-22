class MessagesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :message, :through => :restaurant, :shallow => true

  def show; end

  def new
    load_mention_list
  end

  def create
    if @message.save
      redirect_to [:dashboard, @restaurant], notice: 'Message has been created.'
    else
      load_mention_list
      render :new
    end
  end

  protected

  def load_mention_list
    @mention_list = []

    @restaurant.suppliers.accessible_by(current_ability).each do |supplier|
      @mention_list << {
        id:     "supplier#{supplier.id}",
        name:   supplier.name,
        avatar: get_thumb(supplier.logo),
        type:   :contact
      }
    end

    @restaurant.users.each do |user|
      @mention_list << {
        id:     "user#{user.id}",
        name:   user.name,
        avatar: get_thumb(user.avatar),
        type:   :contact
      }
    end
  end

  def get_thumb(src)
    src.exists? ? src.url(:thumb) : '/assets/' + src.url(:thumb)
  end

  def message_params
    params.require(:message).permit(:title, :content)
  end
end