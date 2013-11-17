class Content

  PREVIEW_ID = 'PREVIEW'
  NEW_CONTENT_ID = 'NEW_CONTENT_ID'
  ROOT_PARENT_ID = Summary::ROOT_PARENT_ID

  def initialize(id)
    @id        = id
    @summary   = Summary.new(id)
    if Summary.exist(id)
      File.open(file_path(), mode = 'r') {|f|
        @content = f.read
      }
    end
  end

  def id
    return @id
  end

  def title
    return @summary == nil ? '' : @summary.title
  end

  def title=(s)
    @summary.title = s
  end

  def parent
    return @summary == nil ? '' : @summary.parent
  end

  def parent=(s)
    @summary.parent = s
  end

  def create_user
    return @summary == nil ? '' : @summary.create_user
  end

  def create_user=(s)
    @summary.create_user = s
  end

  def create_date
    return @summary == nil ? '' : @summary.create_date
  end

  def create_date=(s)
    @summary.create_date = s
  end

  def update_user
    return @summary == nil ? '' : @summary.update_user
  end

  def update_user=(s)
    @summary.update_user = s
  end

  def update_date
    return @summary == nil ? '' : @summary.update_date
  end

  def update_date=(s)
    @summary.update_date = s
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

  def dir_path
    return nil if id() == nil
    return Pathname(Settings.data_path).join(id().to_s[0,1]).join(id().to_s[1,1])
  end

  def file_path
    return nil if dir_path() == nil
    return dir_path().join(id().to_s)
  end

  def breadcrumb_list
    return @summary == nil ? Array.new() : @summary.breadcrumb_list() 
  end

  def child_list
    return @summary == nil ? Array.new() : @summary.child_list() 
  end
  
  def self.child_list(id)
    return Summary.child_list(id)
  end

  def save
    FileUtils.mkdir_p(dir_path()) unless FileTest.exists?(dir_path())
    File.open(file_path(), mode = 'w') {|f|
      f.puts @content
    }
    @summary.update()
    @summary.commit()
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
    File.unlink(file_path())
    child_list().each {|child|
      summary = Summary.new(child[:key])
      summary.parent = parent()
      summary.update()
    }
    @summary.remove()
    @summary.commit()
    return @id
  end

  def self.find(keyword)
    rt = Array.new()
    Summary.ids.each {|id|
      c = Content.new(id.to_s)
      if c.title.index(keyword) || c.content.index(keyword)
        rt.push(c)
      end
    }
    return rt
  end

  def self.exist(id)
    return Summary.exist(id.to_s)
  end

end
