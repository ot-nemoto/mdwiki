# encoding: UTF-8
class StringUtil

  def self.blank?(str = nil)
    return str.blank? || str.gsub(/(\s|　)+/, '').empty?
  end

end
