class LoginController < ApplicationController

  def index
    session[:user_id] = nil
  end

  def login
    rt = Hash.new
    u  = User.find(params[:username])
    if u == nil || !u.auth?(params[:password])
      rt.store('alert', "Invalid username or password.")
    else
      session[:user_id] = u.user
      fullpath = session[:request_path].nil? ? '/mdwiki' : session[:request_path]
      session[:request_path] = nil
      rt.store('href', fullpath)
    end
    render :json => rt
  end

  def logout
    rt = Hash.new
    session[:user_id] = nil
    rt.store('href', '/mdwiki/login')
    render :json => rt
  end

end
