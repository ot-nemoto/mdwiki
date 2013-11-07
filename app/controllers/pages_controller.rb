class PagesController < ApplicationController

  def main
    @summaries = get_list(Settings.root_parent)
    @menu_flg = {:create  => true,  :create_id => Settings.root_parent,
                 :save    => false, :save_cmd  => nil,
                 :preview => false,
                 :remove  => false,
                 :edit    => false, :edit_id   => nil,
                 :cancel  => false, :cancel_id => nil}
    render 'main'
  end

  def list
    @summaries = get_list(params[:id])
    render :partial => "list", :object => @summaries
  end

  def get_list(parent)
    result = Array.new
    SUMMARIES.keys.each {|key|
      if SUMMARIES[key.to_sym][:parent].to_s == parent.to_s
        result.push({:key => key, \
                        :title => SUMMARIES[key.to_sym][:title], \
                        :child => has_children(key)})
      end
    }
    return result.sort {|a,b|
      a[:title] <=> b[:title]
    }
  end

  def has_children(parent)
    SUMMARIES.keys.each {|key|
      return true if SUMMARIES[key.to_sym][:parent].to_s == parent.to_s
    }
    return false
  end

  def show(id = params[:id])
    # Redirect to Top
    if id == Settings.root_parent
      redirect_to '/mdwiki/' and return
    end

    @html_content = Hash.new
    @html_content.store(:title, SUMMARIES[id.to_sym][:title])
    @html_content.store(:create_user, SUMMARIES[id.to_sym][:create_user])
    @html_content.store(:create_date, SUMMARIES[id.to_sym][:create_date])
    @html_content.store(:update_user, SUMMARIES[id.to_sym][:update_user])
    @html_content.store(:update_date, SUMMARIES[id.to_sym][:update_date])

    file_path = Pathname(Settings.data_path).join(id)
    File.open(file_path, mode = 'r') {|f|
      @html_content.store(:content, Kramdown::Document.new(f.read).to_html)
      @content = @html_content[:content]
    }
    @id = id
    @breadcrumb_list = get_breadcrumb_list(SUMMARIES[id.to_sym][:parent])
    @menu_flg = {:create  => true,  :create_id => @id,
                 :save    => false, :save_cmd  => nil,
                 :preview => false,
                 :remove  => true,
                 :edit    => true,  :edit_id   => @id,
                 :cancel  => false, :cancel_id => nil}
  end

  def get_breadcrumb_list(id)
    result = Array.new
    if id != Settings.root_parent
      result = get_breadcrumb_list(SUMMARIES[id.to_sym][:parent])
      result.push({:id => id, :title => SUMMARIES[id.to_sym][:title]})
    end
    return result
  end

  def edit(id = params[:id])
    @md_title = SUMMARIES[id.to_sym][:title]
    file_path = Pathname(Settings.data_path).join(id)
    File.open(file_path, mode = 'r') {|f|
      @md_content = f.read
    }
    @command = 'update'
    @id = params[:id]
    @breadcrumb_list = get_breadcrumb_list(SUMMARIES[id.to_sym][:parent])

    @attachment_list = get_attachment_list(id)
    @menu_flg = {:create  => false, :create_id => nil,
                 :save    => true,  :save_cmd  => 'update',
                 :preview => true,
                 :remove  => false,
                 :edit    => false, :edit_id   => nil,
                 :cancel  => true,  :cancel_id => @id}
    render 'edit'
  end

  def insert(parent_id = params[:id])
    # Validation Check

    rt = Hash.new
    id = Digest::MD5.hexdigest(SecureRandom.uuid)
    unless is_content(id)
      save(id, parent_id)
      rt.store('href', '/mdwiki/' + id)
    end

    render :json => rt
  end

  def update(id = params[:id])
    # Validation Check

    rt = Hash.new
    save(id, SUMMARIES[id.to_sym][:parent], true)
    rt.store('href', '/mdwiki/' + id)

    render :json => rt
  end

  def new(id = params[:id])
    @command = 'insert'
    @id = id
    @breadcrumb_list = get_breadcrumb_list(id)
    @attachment_list = Array.new
    @menu_flg = {:create  => false, :create_id => nil,
                 :save    => true,  :save_cmd  => 'insert',
                 :preview => true,
                 :remove  => false,
                 :edit    => false, :edit_id   => nil,
                 :cancel  => true,  :cancel_id => @id}
    render 'edit'
  end

  def preview
    @html_content = Hash.new
    @html_content.store(:title, params[:md_title])
    @html_content.store(:content, Kramdown::Document.new(params[:md_content]).to_html)

    render :partial => "preview", :object => @html_content
  end

  def upload_attach(id = params[:id])
    a = params[:attachment]
    dir_path = Pathname(Settings.image_path).join(id)
    FileUtils.mkdir_p(dir_path) \
      unless FileTest.exists?(dir_path)
    file_path = dir_path.join(a.original_filename)
    File.open(file_path, mode = 'wb') do |f|
      f.write(a.read)
    end
    @attachment_list = get_attachment_list(id)
    render :partial => "attachment", :object => @attachment_list
  end

  def remove_attach(id = params[:id], filename = params[:file])
    dir_path = Pathname(Settings.image_path).join(id)
    file_path = dir_path.join(filename)
    puts file_path
    File.unlink file_path \
      if FileTest.exists?(file_path)
    @attachment_list = get_attachment_list(id)
    render :partial => "attachment", :object => @attachment_list
  end

  def get_attachment_list(id)
    rt = Hash.new
    attachments = Array.new
    rt.store(:id, id)
    dir_path = Pathname(Settings.image_path).join(id)
    if FileTest.exists?(dir_path)
      Dir::entries(dir_path).each {|f|
        attachments.push(f) \
          if File::ftype(dir_path.join(f)) == 'file'
      }
    end
    rt.store(:file, attachments)
    return rt
  end

  # There is content with the same name?
  def is_content(id)
    file_path = Pathname(Settings.data_path).join(id)
    return FileTest.exist?(file_path)
  end

  def save(id, parent, edit = false)
    update_user = 'anonymous'
    update_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    create_user = edit ? SUMMARIES[id.to_sym][:create_user] : update_user
    create_date = edit ? SUMMARIES[id.to_sym][:create_date] : update_date

    # save content to file
    file_path = Pathname(Settings.data_path).join(id)
    File.open(file_path, mode = 'w') {|f|
      f.puts params[:md_content]
    }

    # save SUMMARIES.keys.eachsummary to json
    summary = Hash.new
    summary.store(:title, params[:md_title])
    summary.store(:parent, parent)
    summary.store(:create_user, create_user)
    summary.store(:create_date, create_date)
    summary.store(:update_user, update_user)
    summary.store(:update_date, update_date)

    SUMMARIES.store(id.to_sym, summary)

    file_path = Pathname(Settings.data_path).join(Settings.summary_file)
    File.open(file_path, mode = 'w') {|f|
      JSON.dump(SUMMARIES, f)
    }
  end

end
