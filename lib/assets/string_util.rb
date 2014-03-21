# encoding: UTF-8
module StringUtil

  def self.blank?(str = nil)
    return str.blank? || str.gsub(/(\s|　)+/, '').empty?
  end
end
