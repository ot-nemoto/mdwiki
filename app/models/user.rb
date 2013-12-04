class User

  def initialize(u = nil)
    if !u.nil?
      @user = u[:user]
      @pass = u[:pass]
      @mail = u[:mail]
    end
  end

  def user
    return @user
  end

  def mail
    return @mail
  end

  def auth?(pass)
    return false if @user.nil? || @user.empty?
    return (@pass.nil? || @pass == pass)
  end

  def self.find(user)
    return nil if user.nil?
    return nil if user.empty?
    USERS[:users].each {|u|
      next if u[:user] != user
      return User.new(u)
    }
    return nil
  end

end
