# encoding: UTF-8
class Content

  PREVIEW_ID = 'PREVIEW'
  NEW_CONTENT_ID = 'NEW_CONTENT_ID'
  ROOT_PARENT_ID = Summary::ROOT_PARENT_ID

  attr_reader :id, :data_root, :dir_path, :file_path, :summary
  attr_accessor :content

  def initialize(id, summary = nil, data_root = Pathname(Settings.data_path))
    @id = id
    @data_root = data_root
    if !id.nil? then
      @dir_path = data_root.join(@id.to_s[0,1]).join(@id.to_s[1,1])
      @file_path = @dir_path.join(@id.to_s)
    end
    @summary = summary.nil? ? Summary.new(id) : summary
    if Summary.exist?(id)
      File.open(@file_path, mode = 'r') {|f|
        @content = f.read
      }
    end
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
    return @summary.nil? ? '' : @summary.update_date
  end

  def update_date=(s)
    @summary.update_date = s
  end

  def content_to_html
    return Kramdown::Document.new(@content).to_html
  end

  def save(is_commit = true)
    FileUtils.mkdir_p(@dir_path) unless FileTest.exist?(@dir_path)
    File.open(file_path(), mode = 'w') {|f|
      f.puts @content
    }
    @summary.update()
    @summary.commit() if is_commit
  end

  def remove_all(is_commit = true)
    rt = Array.new()
    @summary.children.each {|child|
      c = Content.new(child.id, Summary.new(child.id, nil, child.summaries), @data_root)
      c.remove_all(false).each {|removed_id|
        rt.push(removed_id.to_s)
      }
    }
    rt.push(remove(false))
    @summary.commit if is_commit
    return rt
  end

  def remove(is_commit = true)
    File.unlink(@file_path)
    @summary.children.each {|child|
      child.parent = parent
      child.update
    }
    @summary.remove
    @summary.commit if is_commit
    return @id
  end

  def exist_on_title?(keyword)
    return StringUtil.exist?(title(), keyword)
  end

  def exist_on_content?(keyword)
    return StringUtil.exist?(content(), keyword)
  end

  def find?(keyword, chk_title = true, chk_content = true)
    if (chk_title && exist_on_title?(keyword)) || 
       (chk_content && exist_on_content?(keyword))
      return true
    end
    return false
  end

  def self.find(keyword, chk_title = true, chk_content = true, data_root = Pathname(Settings.data_path))
    rt = Array.new()
    Summary.ids.each {|id|
      c = Content.new(id.to_s, nil, data_root)
      if c.find?(keyword, chk_title, chk_content) then
        rt.push(c)
      end
    } if !keyword.blank?
    return rt
  end
end
