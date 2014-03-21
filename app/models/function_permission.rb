class FunctionPermission

  MAIN   = 'main'
  SEARCH = 'search'
  SHOW   = 'show'
  NEW    = 'new'
  EDIT   = 'edit'

  attr_reader :id, :keyword, :save_cmd

  def initialize(type, param = nil)
    case type
    when FunctionPermission::MAIN then
      @create = true
      @id     = param
    when FunctionPermission::SEARCH then
      if !param.nil?
        @keyword = param[:keyword]
        @chk_title = param[:chk_title]
        @chk_content = param[:chk_content]
      end
    when FunctionPermission::SHOW then
      @create = true
      @remove = true
      @edit   = true
      @id     = param
    when FunctionPermission::NEW then
      @save     = true
      @save_cmd = 'insert'
      @preview  = true
      @cancel   = true
      @id       = param
    when FunctionPermission::EDIT then
      @save     = true
      @save_cmd = 'update'
      @preview  = true
      @cancel   = true
      @id       = param
    end
  end

  def create?
    return @create.nil? ? false : @create
  end

  def save?
    return @save.nil? ? false : @save
  end

  def preview?
    return @preview.nil? ? false : @preview
  end

  def remove?
    return @remove.nil? ? false : @remove
  end

  def edit?
    return @edit.nil? ? false : @edit
  end

  def cancel?
    return @cancel.nil? ? false : @cancel
  end

  def chk_title?
    return @chk_title.nil? ? true : @chk_title
  end

  def chk_content?
    return @chk_content.nil? ? true : @chk_content
  end

end
