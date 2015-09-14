# encoding: UTF-8
class Summary

  attr_reader :id, :version
  attr_accessor :title, :parent_id

  def initialize(id)
    @id = id
    @path = Mdwiki::Application.config.summary_file
    @summaries = YAML.load_file(@path)
    if @summaries.key?(@id)
      summary = @summaries[@id]
      @title = summary[:title]
      @parent_id = summary[:parent_id]
      @version = summary[:version]
    end
    yield self if block_given?
  end

  def self.new_id
    loop {
      id = SecureRandom.hex
      return id if !exists?(id)
    }
  end

  def self.exists?(id)
    path = Mdwiki::Application.config.summary_file
    summaries = YAML.load_file(path)
    return summaries.key?(id)
  end

  def save
    @summaries.store(@id, {
      :title => @title,
      :parent_id => @parent_id,
      :version => Time.now.to_i
    })
    open(@path, "w") do |f|
      f.write(YAML.dump(@summaries))
    end
  end

  def delete
    @summaries.each do |key, value|
      @summaries[key][:parent_id] = @parent_id if value[:parent_id] == @id
    end
    @summaries.delete(@id)
    open(@path, "w") do |f|
      f.write(YAML.dump(@summaries))
    end
    return @parent_id
  end

  def move(parent_id)
    @summaries[@id][:parent_id] = parent_id
    open(@path, "w") do |f|
      f.write(YAML.dump(@summaries))
    end
  end

  def tree(parent_id = 'HOME')
    rt = Array.new
    @summaries.each do |id, value|
      rt.push({
        :id => id,
        :title => value[:title],
        :children => tree(id)}) if value[:parent_id] == parent_id
    end
    return rt.sort do |d1, d2|
      if d1[:title] == ContentUtil::DEFAULT_TITLE
        1
      elsif d2[:title] == ContentUtil::DEFAULT_TITLE
        -1
      else
        d1[:title] <=> d2[:title]
      end
    end
  end

  def breadcrumb(id = @parent_id)
    summary = @summaries[id]
    return [] if summary.nil?
    return [{:id => nil, :title => 'HOME'}] if summary[:parent_id].nil?
    rt = breadcrumb(summary[:parent_id])
    rt.concat([{
      :id => id,
      :title => summary[:title]}])
    return rt
  end
end
