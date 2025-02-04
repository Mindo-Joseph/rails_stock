class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.order(created_at: :desc)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:notice] = "Product was successfully created."
      redirect_to @product
    else
      flash.now[:alert] = "Error creating product."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Product was successfully updated."
      redirect_to @product
    else
      flash.now[:alert] = "Error updating product."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = "Product was successfully deleted."
    redirect_to products_url, status: :see_other
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Product not found."
    redirect_to products_path
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :quantity,
      :low_stock_threshold,
      :sku
    )
  end
end
