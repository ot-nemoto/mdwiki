class PagesController < ApplicationController

  def main
    @summaries = Content.child_list(Settings.root_parent)
    @menu_flg = {:create  => true,  :create_id => Settings.root_parent,
                 :save    => false, :save_cmd  => nil,
                 :preview => false,
                 :remove  => false, :remove_id => nil,
                 :edit    => false, :edit_id   => nil,
                 :cancel  => false, :cancel_id => nil}
    render 'main'
  end

  def list(id = params[:id])
    @summaries = Content.child_list(id)
    render :partial => "list", :object => @summaries
  end

  def show(id = params[:id])
    # Redirect to Top
    if id == Settings.root_parent
      redirect_to '/mdwiki/' and return
    end

    if !Content.exist(id)
      redirect_to '/mdwiki/' and return
    end

    @content = Content.new(id)
    @menu_flg = {:create  => true,  :create_id => id,
                 :save    => false, :save_cmd  => nil,
                 :preview => false,
                 :remove  => true,  :remove_id => id,
                 :edit    => true,  :edit_id   => id,
                 :cancel  => false, :cancel_id => nil}
  end

  def new(parent_id = params[:id])
    @content = Content.new(Content::NEW_CONTENT_ID)
    @content.parent = parent_id
    @content.title = ''
    @content.content = ''
    @attachments = Array.new
    @command = 'insert'
    @menu_flg = {:create  => false, :create_id => nil,
                 :save    => true,  :save_cmd  => 'insert',
                 :preview => true,
                 :remove  => false, :remove_id => nil,
                 :edit    => false, :edit_id   => nil,
                 :cancel  => true,  :cancel_id => parent_id}
    render 'edit'
  end

  def edit(id = params[:id])
    @content = Content.new(id)
    @attachments = Attachment.find(id)
    @command = 'update'
    @menu_flg = {:create  => false, :create_id => nil,
                 :save    => true,  :save_cmd  => 'update',
                 :preview => true,
                 :remove  => false, :remove_id => nil,
                 :edit    => false, :edit_id   => nil,
                 :cancel  => true,  :cancel_id => id}
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

  def remove(id = params[:id])
    rt = Hash.new
    if Content.exist(id)
      content = Content.new(id)
      rt.store('href', '/mdwiki/' + content.parent)
      content.remove()
      Attachment.remove(id)
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
    end while is_content(id)
    return id
  end

  # There is content with the same name?
  def is_content(id)
    file_path = Pathname(Settings.data_path).join(id)
    return FileTest.exist?(file_path)
  end

end
