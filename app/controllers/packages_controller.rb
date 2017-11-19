class PackagesController < ApplicationController
  before_action :find_package, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @package = Package.new
  end

  def create
    @package = Package.create(package_params)

    if @package.persisted?
      redirect_to "/users/#{@package.user_id}"
    end
  end

  def show
    @package = Package.find(params[:id])
  end

  def edit
  end

  def update
    if @package.update(package_params)
      redirect_to "/users/#{@package.user_id}", notice: "Package was successfully updated!"
    else
      render edit
    end
  end

  private

  def package_params
    params.require(:package).permit(:name, :price, :count, :signature, :user_id)
  end

  def find_package
    @package = Package.find(params[:id])
  end
end
