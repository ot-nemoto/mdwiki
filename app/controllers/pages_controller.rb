class PagesController < ApplicationController

  def main
    @summaries = Content.child_list(Content::ROOT_PARENT_ID)
    @header_params = HeaderParams.new(HeaderParams::MAIN, Content::ROOT_PARENT_ID)
    render 'main'
  end

  def list(id = params[:id])
    @summaries = Content.child_list(id)
    render :partial => "list", :object => @summaries
  end

  def show(id = params[:id])
    # Redirect to Top
    if id == Content::ROOT_PARENT_ID
      redirect_to '/mdwiki/' and return
    end

    if !Content.exist(id)
      redirect_to '/mdwiki/' and return
    end

    @content = Content.new(id)
    @header_params = HeaderParams.new(HeaderParams::SHOW, id)
  end

  def new(parent_id = params[:id])
    @content = Content.new(Content::NEW_CONTENT_ID)
    @content.parent = parent_id
    @attachments = Array.new
    @header_params = HeaderParams.new(HeaderParams::NEW, parent_id)
    render 'edit'
  end

  def edit(id = params[:id])
    @content = Content.new(id)
    @attachments = Attachment.find(id)
    @header_params = HeaderParams.new(HeaderParams::EDIT, id)
    render 'edit'
  end

  def insert(parent_id = params[:parent_id])
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

    rt = Hash.new
    rt.store('href', '/mdwiki/' + id)
    render :json => rt
  end

  def update(id = params[:id])
    content = Content.new(id)
    content.update_user = session[:user_id]
    content.update_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    content.title = params[:md_title]
    content.content = params[:md_content]
    content.save()

    rt = Hash.new
    rt.store('href', '/mdwiki/' + id)
    render :json => rt
  end

  def remove_all(id = params[:id])
    rt = Hash.new
    if Content.exist(id)
      content = Content.new(id)
      content.remove_all().each {|removed_id|
        Attachment.remove(removed_id) if removed_id != nil
      }
      rt.store('href', '/mdwiki/' + content.parent)
    end
    render :json => rt
  end

  def remove(id = params[:id])
    rt = Hash.new
    if Content.exist(id)
      content = Content.new(id)
      removed_id = content.remove()
      Attachment.remove(removed_id) if removed_id != nil
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

  def upload_attach(id = params[:id], a = params[:attachment])
    Attachment.upload(id, a)
    render :partial => "attachment", 
      :locals => {:id => id, :attachments => Attachment.find(id)}
  end

  def remove_attach(id = params[:id], filename = params[:file])
    Attachment.remove(id, filename)
    render :partial => "attachment", 
      :locals => {:id => id, :attachments => Attachment.find(id)}
  end

  def make_content_id
    id = nil
    begin
      id = Digest::MD5.hexdigest(SecureRandom.uuid)
    end while Content.exist(id)
    return id
  end

end
