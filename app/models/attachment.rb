class Attachment < ActiveRecord::Base
  self.table_name = 'attachments'
  self.primary_keys = :content_id, :filename
  self.record_timestamps = false

  def upload(user, date)
    atch = Attachment.find_by content_id: content_id, filename: filename
    if atch.nil? then
      atch = Attachment.new
      atch.attachment_id = Digest::MD5.hexdigest(SecureRandom.uuid)
      atch.content_id    = content_id
      atch.filename      = filename
    end
    atch.attachment   = attachment
    atch.content_type = content_type
    atch.updated_user = user
    atch.updated_at   = date
    atch.deleted      = false
    atch.save
  end

  def remove(user, date)
    atch = Attachment.find_by attachment_id: attachment_id, deleted: false
    atch.updated_user = user
    atch.updated_at   = date
    atch.deleted      = true
    atch.save
  end

  def self.remove_by_content_id(content_id, user, date)
    atchs = Attachment.where content_id: content_id, deleted: false
    atchs.each do |atch|
      atch.remove user, date
    end
  end
end
