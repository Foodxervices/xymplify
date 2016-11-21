class MessagesController < ApplicationController
  load_and_authorize_resource :restaurant
  load_and_authorize_resource :message, :through => :restaurant, :shallow => true

  def show; end

  def new; end

  def create
    if @message.save
      redirect_to [:dashboard, @restaurant], notice: 'Message has been created.'
    else
      render :new
    end
  end

  protected

  def message_params
    params.require(:message).permit(:title, :content)
  end
end