class ProductsController < ApplicationController
  include Turbo::Streams::Broadcasts

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
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @product }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

 def update
    if @product.update(product_params)
      flash[:notice] = "Product was successfully updated."
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @product }
      end
    else
      render :edit, status: :unprocessable_entity
    end
 end

  def destroy
    @product.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@product) }
      format.html { redirect_to products_url, notice: "Product was successfully deleted." }
    end
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
