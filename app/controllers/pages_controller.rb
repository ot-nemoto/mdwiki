class PagesController < ApplicationController

  def main
    @summaries = Array.new()
    @summaries.push(Summary.new(Content::ROOT_PARENT_ID))
    @f_permit = FunctionPermission.new(FunctionPermission::MAIN, Content::ROOT_PARENT_ID)
    render 'main'
  end

  def list(id = params[:id], current_id = params[:current_id])
    @summaries = Array.new()
    @summaries.push(Summary.new(id))
    render :partial => "list", :locals => {
      :summaries => @summaries, :current_id => current_id}
  end

  def show(id = params[:id])
    # Redirect to Top
    if id == Content::ROOT_PARENT_ID
      redirect_to '/mdwiki/' and return
    end

    if !Summary.exist?(id)
      redirect_to '/mdwiki/' and return
    end

    @content = Content.new(id)
    @summaries = Array.new()
    @summaries.push(Summary.new(Content::ROOT_PARENT_ID))
    @content.summary.parents.each {|summary|
      @summaries.push(summary)
    }
    @f_permit = FunctionPermission.new(FunctionPermission::SHOW, id)
  end

  def new(parent_id = params[:id])
    @content = Content.new(Content::NEW_CONTENT_ID)
    @content.parent = parent_id
    @attachments = Array.new
    @f_permit = FunctionPermission.new(FunctionPermission::NEW, parent_id)
    render 'edit'
  end

  def edit(id = params[:id])
    @content = Content.new(id)
    @attachments = Attachment.where content_id: id, deleted: false
    @f_permit = FunctionPermission.new(FunctionPermission::EDIT, id)
    render 'edit'
  end

  def insert(parent_id = params[:parent_id])
    rt = Hash.new
    if StringUtil.blank?(params[:md_title])
      rt.store('alert', "Title has not been entered.")
      render :json => rt and return
    end
    id = make_content_id()
    content = Content.new(id)
    content.parent = parent_id
    content.update_user = session[:user_id]
    content.update_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    content.create_user = content.update_user
    content.create_date = content.update_date
    content.title = params[:md_title]
    content.content = params[:md_content]
    content.save()

    rt.store('href', '/mdwiki/' + id)
    render :json => rt
  end

  def update(id = params[:id])
    rt = Hash.new
    if StringUtil.blank?(params[:md_title])
      rt.store('alert', "Title has not been entered.")
      render :json => rt and return
    end
    content = Content.new(id)
    content.update_user = session[:user_id]
    content.update_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    content.title = params[:md_title]
    content.content = params[:md_content]
    content.save()

    rt.store('href', '/mdwiki/' + id)
    render :json => rt
  end

  def remove_all(id = params[:id])
    rt = Hash.new
    if Summary.exist?(id)
      content = Content.new(id)
      content.remove_all().each do |removed_content_id|
        if !removed_content_id.nil?
          Attachment.remove_by_content_id removed_content_id, session[:user_id], Time.now
        end
      end
      rt.store('href', '/mdwiki/' + content.parent)
    end
    render :json => rt
  end

  def remove(id = params[:id])
    rt = Hash.new
    if Summary.exist?(id)
      content = Content.new(id)
      removed_content_id = content.remove()
      if !removed_content_id.nil?
        Attachment.remove_by_content_id removed_content_id, session[:user_id], Time.now
      end
      rt.store('href', '/mdwiki/' + content.parent)
    end
    render :json => rt
  end

  def preview
    @content = Content.new(Content::PREVIEW_ID)
    @content.title = params[:md_title]
    @content.content = params[:md_content]
    render :partial => "preview", :object => @content
  end

  def make_content_id
    id = nil
    begin
      id = Digest::MD5.hexdigest(SecureRandom.uuid)
    end while Summary.exist?(id)
    return id
  end

end
