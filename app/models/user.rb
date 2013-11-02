class User

  def self.find(username)
    USERS[:users].each {|u|
      next if u[:user] != username
      return u
    }
    return nil
  end

  def self.exist(username)
    return find(username) != nil
  end

end
