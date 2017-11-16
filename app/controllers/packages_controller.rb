class PackagesController < ApplicationController
  def index
    @package = Package.new
  end

  def create
    @package = Package.create(package_params)

    if @package.persisted?
      render action: "show"
    end
  end

  def show
    @package = Package.find(params[:id])
  end

  private

  def package_params
    params.require(:package).permit(:name, :price, :count, :signature, :user_id)
  end
end
