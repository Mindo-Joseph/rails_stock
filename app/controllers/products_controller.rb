require 'csv'

class ProductsController < ApplicationController
  include Turbo::Streams::Broadcasts
  include ActionView::Helpers::NumberHelper
  helper_method :format_price
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all
    @products = @products.search(params[:query]) if params[:query].present?
    @products = @products.by_stock_status(params[:status]) if params[:status].present?
    @products = @products.order(created_at: :desc)
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

  def export
    @products = Product.order(created_at: :desc)

    respond_to do |format|
      format.csv do
        send_data generate_csv(@products),
          filename: "inventory-#{Date.current}.csv",
          type: 'text/csv'
      end
      format.xlsx do
        send_data generate_xlsx(@products),
          filename: "inventory-#{Date.current}.xlsx",
          type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Product not found."
    redirect_to products_path
  end

   def format_price(price)
    number_to_currency(price, unit: "KES")
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

  def stock_status_label(product)
    if product.quantity.zero?
      'Out of Stock'
    elsif product.quantity <= product.low_stock_threshold
      'Low Stock'
    else
      'In Stock'
    end
  end
  
  def generate_csv(products)
    headers = ['Name', 'SKU', 'Description', 'Price', 'Quantity', 'Low Stock Threshold', 'Status', 'Created At']

    CSV.generate(headers: true) do |csv|
      csv << headers
      products.each do |product|
        csv << [
          product.name,
          product.sku,
          product.description,
          format_price(product.price),
          product.quantity,
          product.low_stock_threshold,
          stock_status_label(product),
          product.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end
  end

  def generate_xlsx(products)
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Inventory") do |sheet|
      sheet.add_row ['Name', 'SKU', 'Description', 'Price', 'Quantity', 'Low Stock Threshold', 'Status', 'Created At']
      products.each do |product|
        sheet.add_row [
          product.name,
          product.sku,
          product.description,
          format_price(product.price),
          product.quantity,
          product.low_stock_threshold,
          stock_status_label(product),
          product.created_at.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
    end

    package.to_stream.read
  end
end
