# encoding: UTF-8
class Page

  attr_accessor :id

  def initialize(id = nil)
    @id = id.blank? ? SecureRandom.hex : id
    @dirname = Mdwiki::Application.config.pages_path
    @dirname = File.join(@dirname, @id[0,1]) if @id != 'HOME'
    @path = File.join(@dirname, @id)
    yield self if block_given?
  end

  def self.new_id
    return SecureRandom.hex
  end

  def content
    @content = (FileTest.exist?(@path) ? File.open(@path).read : nil) if @content.nil?
    return @content
  end

  def content=(s)
    @content = s
  end

  def md_to_html
    return Kramdown::Document.new(content.to_s).to_html
  end

  def save
    return if @content.nil?
    FileUtils.mkdir(@dirname) if !FileTest::directory?(@dirname)
    File.open(@path, 'w') do |f|
      f.write @content
    end
  end

  def delete
    return unless FileTest.exist?(@path)
    File.unlink(@path)
  end
end
