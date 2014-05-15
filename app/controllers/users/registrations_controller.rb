class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [:cancel]
  prepend_before_filter :authenticate_scope!, :only => [:new, :create ,:edit, :update, :destroy]

  def cancel
    super
  end

  def create
    if !current_user.try(:admin?) then
      flash[:alert] = I18n.t("mdwiki.failure.permission_denied")
      redirect_to after_sign_in_path_for(resource)
    else
      super
      if params[:admin_flg] then
        user = User.find_by email: params[:user][:email]
        user.admin = params[:admin_flg]
        user.save!
      end
    end
  end

  def new
    @header_params = {
      :create => false,
      :save => false,
      :preview => false,
      :remove => false,
      :edit => false,
      :cancel => false,
      :find_by_subject => true,
      :find_by_content => true,
      :keywords => nil,
      :id => nil
    }
    if !current_user.try(:admin?) then
      flash[:alert] = I18n.t("mdwiki.failure.permission_denied")
      redirect_to after_sign_in_path_for(resource)
    else
      super
    end
  end

  def edit
    @header_params = {
      :create => false,
      :save => false,
      :preview => false,
      :remove => false,
      :edit => false,
      :cancel => false,
      :find_by_subject => true,
      :find_by_content => true,
      :keywords => nil,
      :id => nil
    }
    super
  end

  def update
    super
  end

  def destroy
    super
  end
end
