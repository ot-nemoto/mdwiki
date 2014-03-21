module Enum
  module Role
    READER = 0
    EDITOR = 1
    ADMIN  = 2
  
    def self.values
      return self.constants
    end
  
    def self.value_of(name = nil)
      return nil if name.nil?
      self.values.each {|v|
        if v.downcase.to_s == name.downcase.to_s
          return self.const_get(v)
        end
      }
      return nil
    end
  end
end
