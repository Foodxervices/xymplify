module FoodItemHelper
  def attachments_preview(attachments)
    attachments.map{ |attachment| asset_url(attachment.file.url) }
  end

  def attachments_preview_config(attachments)
    config = []
    
    attachments.each do |attachment|
      config << {
        type: attachment.file_content_type == 'application/pdf' ? 'pdf' : 'image',
        url: attachment_url(attachment, method: :delete),
        key: attachment.id,
        extra: {
          id: attachment.id
        }
      }
    end

    config
  end
end
