class Summary

  ROOT_PARENT_ID = 'ROOT'

  attr_accessor :title, :parent, :create_user, :create_date, :update_user, :update_date
  attr_reader :id, :summary_path, :summaries

  def initialize(
    id, summary_path = Pathname(Settings.data_path).join(Settings.summary_file), summaries = SUMMARIES)
    @id           = id
    @summary_path = summary_path
    @summaries    = summaries
    s = @summaries[@id.to_sym]
    if !s.nil? then
      @title       = s[:title]
      @parent      = s[:parent]
      @create_user = s[:create_user]
      @create_date = s[:create_date]
      @update_user = s[:update_user]
      @update_date = s[:update_date]
    end
  end

  def parents
    return Summary.parents(@parent, @summaries)
  end

  def self.parents(id, summaries = SUMMARIES)
    rt = Array.new
    if id != Summary::ROOT_PARENT_ID
      rt = Summary.parents(summaries[id.to_sym][:parent], summaries)
      rt.push(Summary.new(id.to_sym, nil, summaries))
    end
    return rt
  end

  def children
    return Summary.children(@id, @summaries)
  end
  
  def self.children(id, summaries = SUMMARIES)
    rt = Array.new
    summaries.keys.each {|idy|
      summary = Summary.new(idy, nil, summaries)
      if summary.parent.to_s == id.to_s
        rt.push(summary)
      end
    }
    return rt.sort {|a,b| a.title <=> b.title }
  end

  def children_exist?
    Summary.ids(@summaries).each {|idy|
      return true if @summaries[idy.to_sym][:parent].to_s == @id.to_s
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
    @summaries.store(@id.to_sym, items)
  end

  def remove
    @summaries.delete(@id.to_sym)
  end

  def commit
    File.open(@summary_path, mode = 'w') {|f|
      JSON.dump(@summaries, f)
    }
  end

  def self.ids(summaries = SUMMARIES)
    return summaries.keys
  end

  def self.exist?(id, summaries = SUMMARIES)
    return false if id.nil?
    return (summaries[id.to_sym] != nil)
  end
end
