class PagesController < ApplicationController

  def main
    @summaries = [ Content.new(content_id: Content::ROOT_PARENT_ID, deleted: false) ]
    @f_permit = FunctionPermission.new(FunctionPermission::MAIN, Content::ROOT_PARENT_ID)
    render 'main'
  end

  def list(content_id = params[:id], current_id = params[:current_id])
    @summaries = [ Content.new(content_id: content_id, deleted: false) ]
    render :partial => "list", :locals => {
      :summaries => @summaries, :current_id => current_id}
  end

  def show(content_id = params[:id])
    if content_id == Content::ROOT_PARENT_ID
      redirect_to '/mdwiki/' and return
    end

    @content = Content.find_by content_id: content_id, deleted: false
    if @content.nil?
      redirect_to '/mdwiki/' and return
    end

    @summaries = [ Content.new(content_id: Content::ROOT_PARENT_ID, deleted: false) ]
    @content.breadcrumb_list.reverse.each {|summary|
      @summaries.push summary
    }
    @f_permit = FunctionPermission.new(FunctionPermission::SHOW, content_id)
  end

  def new(parent_id = params[:id])
    @content = Content.new content_id: Content::NEW_CONTENT_ID, parent_id: parent_id
    @attachments = Array.new
    @f_permit = FunctionPermission.new(FunctionPermission::NEW, parent_id)
    render 'edit'
  end

  def edit(content_id = params[:id])
    @content = Content.find_by content_id: content_id, deleted: false
    @attachments = Attachment.where content_id: content_id, deleted: false
    @f_permit = FunctionPermission.new(FunctionPermission::EDIT, content_id)
    render 'edit'
  end

  def save
    rt = Hash.new
    if params[:content_id].empty? || params[:content_id] == Content::NEW_CONTENT_ID then
      content = Content.new
      content.content_id = Digest::MD5.hexdigest(SecureRandom.uuid)
      content.parent_id  = params[:parent_id]
      content.subject = params[:subject]
      content.content = params[:content]
      content.insert session[:user_id], Time.now
    else
      content = Content.find_by content_id: params[:content_id]
      content.subject = params[:subject]
      content.content = params[:content]
      content.update session[:user_id], Time.now
    end
    rt.store('href', "/mdwiki/#{content.content_id}")
    render :json => rt
  end

  def remove_all(content_id = params[:id])
    rt = Hash.new
    content = Content.find_by content_id: content_id, deleted: false
    if !content.nil?
      removed_content_ids = content.remove_all session[:user_id], Time.now
      removed_content_ids.each do |removed_content_id|
        Attachment.remove_by_content_id removed_content_id, session[:user_id], Time.now
      end
      rt.store('href', "/mdwiki/#{content.parent_id}")
    end
    render :json => rt
  end

  def remove(content_id = params[:id])
    rt = Hash.new
    content = Content.find_by content_id: content_id, deleted: false
    if !content.nil?
      removed_content_id = content.remove session[:user_id], Time.now
      Attachment.remove_by_content_id removed_content_id, session[:user_id], Time.now
      rt.store('href', "/mdwiki/#{content.parent_id}")
    end
    render :json => rt
  end

  def preview
    @content = Content.new(
      content_id: Content::PREVIEW_ID,
      subject: params[:subject],
      content: params[:content])
    render :partial => "preview", :object => @content
  end

end
