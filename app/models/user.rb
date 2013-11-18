class User

  def initialize(u)
    @user = u[:user]
    @pass = u[:pass]
    @mail = u[:mail]
  end

  def user
    return @user
  end

  def mail
    return @mail
  end

  def auth(pass)
    return (@pass == nil || @pass == pass)
  end

  def self.find(user)
    USERS[:users].each {|u|
      next if u[:user] != user
      return User.new(u)
    }
    return nil
  end

end
