class AttachmentController < ApplicationController
  def show(attachment_id = params[:id])
    atch = Attachment.find_by attachment_id: attachment_id
    send_data atch.attachment, type: atch.content_type, disposition: :inline, filename: atch.filename
  end

  def upload(content_id = params[:id], attachment = params[:attachment])
    begin
      atch = Attachment.new
      atch.content_id   = content_id
      atch.filename     = attachment.original_filename
      atch.attachment   = attachment.read
      atch.content_type = attachment.content_type
      atch.upload current_user.email, Time.now
    rescue => e
      logger.error e.message
    ensure
      @atchs = Attachment.where content_id: content_id, deleted: false
      render :partial => 'attachment', :locals => { :id => content_id, :attachments => @atchs }
    end
  end

  def remove(content_id = params[:id], attachment_id = params[:attachment_id])
    begin
      atch = Attachment.new
      atch.attachment_id = attachment_id
      atch.remove current_user.email, Time.now
    rescue => e
      logger.error e.message
    ensure
      @atchs = Attachment.where content_id: content_id, deleted: false
      render :partial => 'attachment', :locals => { :id => content_id, :attachments => @atchs }
    end
  end
end
