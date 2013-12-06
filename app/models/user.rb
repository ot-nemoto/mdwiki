class User

  DEFAULT_ROLE = RoleModule::READER

  def initialize(u)
    @user = u[:user]
    @pass = u[:pass]
    @mail = u[:mail]
    @role = u[:role]
  end

  def user
    return @user
  end

  def mail
    return @mail
  end

  def auth?(pass)
    return (@pass == nil || @pass == pass)
  end

  def role
    rt = RoleModule.value_of(@role)
    return rt.nil? ? DEFAULT_ROLE : rt
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
