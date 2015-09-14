# encoding: utf-8
module ContentUtil
  DEFAULT_TITLE = 'No title'

  def self.extract_title(content)
    content.each_line do |line|
      m = line.match(/^# (.+)$/)
      return m[1].chomp if !m.nil?
      break
    end
    return DEFAULT_TITLE
  end
end
