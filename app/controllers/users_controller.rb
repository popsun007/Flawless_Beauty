class UsersController < ApplicationController
	before_action :find_user, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!

  def index
  	@users = User.search(params[:search])
  end

	def show
  end
	
	def edit
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

	private

	def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :birthday, :email, :password, :password_confirmation)
  end

  def find_user
  	@user = User.find(params[:id])
  end
end
