class AttachmentsController < ApplicationController
  def create
    @attachment = Attachment.new(attachment_params)
    
    if @attachment.save
      render json: { id: @attachment.id }
    else
      render json: @attachment.errors.full_messages.join("\r\n"), status: 422
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    authorize!(@attachment.food_item, :update) if @attachment.food_item.present?

    render json: { success: @attachment.destroy }
  end

  private 

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end