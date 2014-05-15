class Users::SessionsController < Devise::SessionsController
  def new
    if request.referer.nil?
      flash.now[:alert] = nil
    end
    super
  end
 
  def create
    super
  end
 
  def destroy
    super
  end
end
