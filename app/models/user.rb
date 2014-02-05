class User

  DEFAULT_ROLE = RoleModule::READER

  attr_reader :user, :mail

  def initialize(u = nil)
    if !u.nil?
      @user = u[:user]
      @pass = u[:pass]
      @mail = u[:mail]
      @role = u[:role]
    end
  end

  def auth?(pass)
    return false if @user.nil? || @user.empty?
    return (@pass.nil? || @pass == Digest::SHA256.hexdigest(pass))
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
