class Content < ActiveRecord::Base
  self.table_name = 'contents'
  self.primary_key = :content_id
  self.record_timestamps = false

  PREVIEW_ID = 'PREVIEW'
  NEW_CONTENT_ID = 'NEW_CONTENT_ID'
  ROOT_PARENT_ID = 'ROOT'

  def md_to_html
    return Kramdown::Document.new(content.to_s).to_html
  end

  def breadcrumb_list(base_content_id = content_id)
    rt = Array.new
    if parent_id != Content::ROOT_PARENT_ID then
      c = Content.find_by content_id: parent_id, deleted: false
      rt.push c
      rt = rt + c.breadcrumb_list(base_content_id)
    end
    return rt
  end

  def children
    Content.where(["parent_id = ? and deleted = false", content_id]).order('subject ASC')
  end

  def children?
    Content.where(["parent_id = ? and deleted = false", content_id]).size > 0
  end

  def insert(user, date)
    c = Content.new
    c.content_id   = content_id
    c.parent_id    = parent_id
    c.subject      = subject
    c.content      = content
    c.created_user = user
    c.created_at   = date
    c.updated_user = user
    c.updated_at   = date
    c.save
  end

  def update(user, date)
    c = Content.find_by content_id: content_id
    c.subject      = subject
    c.content      = content
    c.updated_user = user
    c.updated_at   = date
    c.save
  end

  def remove(user, date)
    c = Content.find_by content_id: content_id
    c.children.each {|child|
      child.parent_id = c.parent_id
      child.save
    }
    c.updated_user = user
    c.updated_at   = date
    c.deleted      = true
    c.save
    return content_id
  end

  def remove_all(user, date)
    removed_content_ids = []
    c = Content.find_by content_id: content_id
    c.children.each {|child|
      removed_content_ids.concat(child.remove_all user, date)
    }
    c.updated_user = user
    c.updated_at   = date
    c.deleted      = true
    c.save
    removed_content_ids.concat([content_id])
    return removed_content_ids
  end
end
