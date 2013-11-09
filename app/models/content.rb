class Content

  PREVIEW_ID = 'PREVIEW'
  NEW_CONTENT_ID = 'NEW_CONTENT_ID'

  @@id
  @@title
  @@parent
  @@create_user
  @@create_date
  @@update_user
  @@update_date

  @@file_path
  @@content

  def initialize(id)
    @@id          = id
    @@file_path = Pathname(Settings.data_path).join(@@id)
    if Content.exist(id)
      s             = SUMMARIES[id.to_sym]
      @@title       = s[:title]
      @@parent      = s[:parent]
      @@create_user = s[:create_user]
      @@create_date = s[:create_date]
      @@update_user = s[:update_user]
      @@update_date = s[:update_date]
      File.open(@@file_path, mode = 'r') {|f|
        @@content     = f.read
      }
    end
  end

  def id
    return @@id
  end

  def title
    return @@title
  end

  def title=(s)
    @@title = s
  end

  def parent
    return @@parent
  end

  def parent=(s)
    @@parent = s
  end

  def self.parent(id)
    return SUMMARIES[id.to_sym][:parent]
  end

  def create_user
    return @@create_user
  end

  def create_user=(s)
    @@create_user = s
  end

  def create_date
    return @@create_date
  end

  def create_date=(s)
    @@create_date = s
  end

  def update_user
    return @@update_user
  end

  def update_user=(s)
    @@update_user = s
  end

  def update_date
    return @@update_date
  end

  def update_date=(s)
    @@update_date = s
  end

  def file_path
    return @@file_path
  end

  def content
    return @@content
  end

  def content=(s)
    @@content = s
  end

  def content_to_html
    return Kramdown::Document.new(@@content).to_html
  end

  def breadcrumb_list
    return self.class.breadcrumb_list(@@parent)
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
    return self.class.breadcrumb_list(@@id)
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

  def save
    File.open(@@file_path, mode = 'w') {|f|
      f.puts @@content
    }

    # save SUMMARIES.keys.eachsummary to json
    summary = Hash.new
    summary.store(:title, @@title)
    summary.store(:parent, @@parent)
    summary.store(:create_user, @@create_user)
    summary.store(:create_date, @@create_date)
    summary.store(:update_user, @@update_user)
    summary.store(:update_date, @@update_date)

    SUMMARIES.store(@@id.to_sym, summary)

    file_path = Pathname(Settings.data_path).join(Settings.summary_file)
    File.open(file_path, mode = 'w') {|f|
      JSON.dump(SUMMARIES, f)
    }
  end

  def remove
    #File.unlink(@@file_path)
  end

  def self.exist(id)
    return (SUMMARIES[id.to_sym] != nil)
  end

end
