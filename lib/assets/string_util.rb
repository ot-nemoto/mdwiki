# encoding: UTF-8
module StringUtil

  def self.blank?(str)
    return str.blank? || str.gsub(/(\s|　)+/, '').empty?
  end

  def self.trim(str)
    return str if str.nil?
    return str.gsub(/(^(\s|　)+)|((\s|　)+$)/, '')
  end

  def self.exist?(value, keywords)
    return false if value.nil? || keywords.nil?
    ks = StringUtil.trim(keywords)
    return false if ks.empty?
    ks.split(/\s|　/).each {|keyword|
      return false if value.index(keyword).nil?
    }
    return true
  end
end
