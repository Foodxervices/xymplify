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
    
    if @attachment.food_item.present? && cannot?(:update, @attachment.food_item)
      return render json: 'You are not authorized to delete this file.', status: 403
    end

    render json: { success: @attachment.destroy }
  end

  private 

  def attachment_params
    params.require(:attachment).permit(:file)
  end
end