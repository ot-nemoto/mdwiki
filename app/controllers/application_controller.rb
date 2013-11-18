class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorize, :except => [ :index, :login ]

  private
  def authorize
    unless User.find(session[:user_id])
      redirect_to '/mdwiki/login'
    end
  end

end
