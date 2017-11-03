class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [:cancel]

def new
	if current_user.try(:admin?)
		build_resource({})
    set_minimum_password_length
    yield resource if block_given?
    respond_with self.resource
	end
end

private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :phone, :birthday, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :phone, :birthday, :email, :password, :password_confirmation)
  end
  
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
