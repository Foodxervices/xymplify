class AddTimestampToAttachment < ActiveRecord::Migration
  def change
    add_timestamps :attachments
  end
end
