class Summary

  def initialize(id)
    @id = id
    s   = SUMMARIES[id.to_sym]
    if s != nil
      @title       = s[:title]
      @parent      = s[:parent]
      @create_user = s[:create_user]
      @create_date = s[:create_date]
      @update_user = s[:update_user]
      @update_date = s[:update_date]
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

  def breadcrumb_list
    return self.class.breadcrumb_list(parent())
  end

  def self.breadcrumb_list(id)
    rt = Array.new()
    if id != Settings.root_parent
      rt = Summary.breadcrumb_list(SUMMARIES[id.to_sym][:parent])
      rt.push({:id => id, :title => SUMMARIES[id.to_sym][:title]})
    end
    return rt
  end

  def child_list
    return self.class.child_list(@id)
  end
  
  def self.child_list(id)
    result = Array.new()
    SUMMARIES.keys.each {|key|
      if SUMMARIES[key.to_sym][:parent].to_s == id.to_s
        result.push({
          :key => key,
          :title => SUMMARIES[key.to_sym][:title],
          :child => Summary.has_child(key)})
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

  def update
    items = Hash.new
    items.store(:title, @title)
    items.store(:parent, @parent)
    items.store(:create_user, @create_user)
    items.store(:create_date, @create_date)
    items.store(:update_user, @update_user)
    items.store(:update_date, @update_date)
    SUMMARIES.store(@id.to_sym, items)
  end

  def remove
    SUMMARIES.delete(@id.to_sym)
  end

  def commit
    file_path = Pathname(Settings.data_path).join(Settings.summary_file)
    File.open(file_path, mode = 'w') {|f|
      JSON.dump(SUMMARIES, f)
    }
  end

  def self.exist(id)
    return (SUMMARIES[id.to_sym] != nil)
  end

end
