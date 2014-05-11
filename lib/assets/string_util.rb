# encoding: UTF-8
module StringUtil

  def self.blank?(str)
    return str.blank? || str.gsub(/(\s|　)+/, '').empty?
  end

  def self.trim(str)
    return str if str.nil?
    return str.gsub(/(^(\s|　)+)|((\s|　)+$)/, '')
  end

end
