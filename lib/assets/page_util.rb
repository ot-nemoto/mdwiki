# encoding: UTF-8
module PageUtil
  def self.extract_title(content)
    content.each_line do |line|
      m = line.match(/^# (.+)$/)
      return m[1].chomp if !m.nil?
      break
    end
    return 'No title'
  end
end
