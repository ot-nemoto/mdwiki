class Content

  PREVIEW_ID = 'PREVIEW'
  NEW_CONTENT_ID = 'NEW_CONTENT_ID'

  def initialize(id)
    @id        = id
    @file_path = Pathname(Settings.data_path).join(@id.to_s)
    @summary   = Summary.new(id)
    if Summary.exist(id)
      File.open(@file_path, mode = 'r') {|f|
        @content     = f.read
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
    return @summary == nil ? Array.new() : @summary.breadcrumb_list() 
  end

  def child_list
    return @summary == nil ? Array.new() : @summary.child_list() 
    #return self.class.child_list(@id)
  end
  
  def self.child_list(id)
    return Summary.child_list(id)
  end

  def save
    File.open(@file_path, mode = 'w') {|f|
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
    File.unlink(@file_path)
    @summary.remove()

    child_list().each {|child|
      summary = Summary.new(child[:key])
      summary.parent = @parent
      summary.update()
    }
    @summary.commit()
    return @id
  end

  def self.exist(id)
    return Summary.exist(id)
  end

end
