class User

  DEFAULT_ROLE = Enum::Role::READER

  attr_reader :user, :mail

  def initialize(u = nil)
    if !u.nil?
      @user = u[:user]
      @pass = u[:pass]
      @mail = u[:mail]
      @role = u[:role]
    end
  end

  def auth?(input_pass)
    return false if @user.nil? || @user.empty?
    return true if @pass.nil?
    return false if input_pass.nil?
    return (@pass == Digest::SHA256.hexdigest(input_pass))
  end

  def role
    rt = Enum::Role.value_of(@role)
    return rt.nil? ? DEFAULT_ROLE : rt
  end

  def self.find(user, user_list = USERS[:users])
    return nil if user.nil?
    return nil if user.empty?
    user_list.each {|u|
      next if u[:user] != user
      return User.new(u)
    }
    return nil
  end
end
