class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.order("created_at DESC")
  end

  def new
    @product = current_user.products.build
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      redirect_to @product, notice: "Successfully created a new product"
    else
      render 'new'
    end
  end

  def show

  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated!"
    else
      render edit
    end
  end

  def destroy
    @product.destroy
    redirect_to action: "index"
  end


  private

  def product_params
    params.require(:product).permit(:name, :description, :image)
  end

  def find_product
    @product = Product.find(params[:id])
  end
end
