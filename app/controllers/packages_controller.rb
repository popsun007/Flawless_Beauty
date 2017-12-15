class PackagesController < ApplicationController
  before_action :find_package, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @package = Package.new
  end

  def create
    @package = Package.create(package_params)
    package_record = PackageHistory.create(
      signature: "",
      package_id: @package.id
    )

    if @package.persisted? && package_record.persisted?
      redirect_to "/users/#{@package.user_id}"
    else
      render new
    end
  end

  def show
    @package = Package.find(params[:id])
  end

  def edit
  end

  def update
    package_update = @package.update(
      name:    package_params[:name],
      price:   package_params[:price],
      count:   package_params[:count],
      user_id: package_params[:user_id]
    )

    history_update = PackageHistory.find_by(package_id: @package.id).update(
      signature:  package_params[:package_histories_attributes]["0"][:signature],
      package_id: @package.id
    )

    if package_update && history_update
      redirect_to "/users/#{@package.user_id}", notice: "Package was successfully updated!"
    else
      render edit
    end
  end

  def destroy
    user_id = @package.user_id
    @package.destroy
    redirect_to "/users/#{user_id}"
  end

  private

  def package_params
    params.require(:package).permit(:name, :price, :count, :user_id, package_histories_attributes: [:id, :signature, :package_id])
  end

  def find_package
    @package = Package.find(params[:id])
  end
end
