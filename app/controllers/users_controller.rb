class UsersController < ApplicationController
  def index
  	@users = User.all
  end
	
	def edit
		@user = User.find(params[:id])
	end


	def update
		if params[:user][:password].blank?
		  params[:user].delete(:password)
		  params[:user].delete(:password_confirmation)
		end

		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to show
		else
			render edit
		end
	end

	def show
		@user = User.find(params[:id])
  end

	private

	def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :birthday, :email, :password, :password_confirmation)
  end
end
