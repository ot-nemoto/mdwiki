class Content

  PREVIEW_ID = 'PREVIEW'
  NEW_CONTENT_ID = 'NEW_CONTENT_ID'

  def initialize(id)
    @id          = id
    @file_path = Pathname(Settings.data_path).join(@id.to_s)
    if Content.exist(id)
      s             = SUMMARIES[id.to_sym]
      @title       = s[:title]
      @parent      = s[:parent]
      @create_user = s[:create_user]
      @create_date = s[:create_date]
      @update_user = s[:update_user]
      @update_date = s[:update_date]
      File.open(@file_path, mode = 'r') {|f|
        @content     = f.read
      }
    end
  end

  def id
    return @id
  end

  def title
    return @title
  end

  def title=(s)
    @title = s
  end

  def parent
    return @parent
  end

  def parent=(s)
    @parent = s
  end

  def self.parent(id)
    return SUMMARIES[id.to_sym][:parent]
  end

  def create_user
    return @create_user
  end

  def create_user=(s)
    @create_user = s
  end

  def create_date
    return @create_date
  end

  def create_date=(s)
    @create_date = s
  end

  def update_user
    return @update_user
  end

  def update_user=(s)
    @update_user = s
  end

  def update_date
    return @update_date
  end

  def update_date=(s)
    @update_date = s
  end

  def file_path
    return @file_path
  end

  def content
    return @content
  end

  def content=(s)
    @content = s
  end

  def content_to_html
    return Kramdown::Document.new(@content).to_html
  end

  def breadcrumb_list
    return self.class.breadcrumb_list(@parent)
  end

  def self.breadcrumb_list(id)
    rt = Array.new
    if id != Settings.root_parent
      rt = Content.breadcrumb_list(SUMMARIES[id.to_sym][:parent])
      rt.push({:id => id, :title => SUMMARIES[id.to_sym][:title]})
    end
    return rt
  end

  def child_list
    return self.class.child_list(@id)
  end
  
  def self.child_list(id)
    result = Array.new
    SUMMARIES.keys.each {|key|
      if SUMMARIES[key.to_sym][:parent].to_s == id.to_s
        result.push({
          :key => key,
          :title => SUMMARIES[key.to_sym][:title],
          :child => Content.has_child(key)})
      end
    }
    return result.sort {|a,b|
      a[:title] <=> b[:title]
    }
  end

  def self.has_child(id)
    SUMMARIES.keys.each {|key|
      return true if SUMMARIES[key.to_sym][:parent].to_s == id.to_s
    }
    return false
  end

  def summary
    rt = Hash.new
    rt.store(:title, @title)
    rt.store(:parent, @parent)
    rt.store(:create_user, @create_user)
    rt.store(:create_date, @create_date)
    rt.store(:update_user, @update_user)
    rt.store(:update_date, @update_date)
    return rt
  end

  def save
    File.open(@file_path, mode = 'w') {|f|
      f.puts @content
    }
    update_summary()
    commit_summary()
  end

  def remove_all
    rt = Array.new()
    child_list().each {|child|
      c = Content.new(child[:key])
      c.remove_all().each {|removed_id|
        rt.push(removed_id)
      }
    }
    rt.push(remove())
    return rt
  end

  def remove
    File.unlink(@file_path)
    remove_summary()

    child_list().each {|child|
      c = Content.new(child[:key])
      c.parent = @parent
      c.update_summary()
    }
    commit_summary()
    return @id
  end

  def update_summary
    SUMMARIES.store(@id.to_sym, summary())
  end

  def remove_summary
    SUMMARIES.delete(@id.to_sym)
  end

  def commit_summary
    file_path = Pathname(Settings.data_path).join(Settings.summary_file)
    File.open(file_path, mode = 'w') {|f|
      JSON.dump(SUMMARIES, f)
    }
  end

  def self.exist(id)
    return (SUMMARIES[id.to_sym] != nil)
  end

end
