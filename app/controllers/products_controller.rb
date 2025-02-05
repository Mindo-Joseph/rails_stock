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
  respond_to do |format|
    format.html
    format.turbo_stream { render @product }
  end
end

  def new
    @product = Product.new
  end

  def create
  @product = Product.new(product_params)

  if @product.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append("flash-messages", partial: "shared/flash_message", locals: { type: "notice", message: "Product was successfully created." }),
          turbo_stream.prepend("products", partial: "product", locals: { product: @product }),
          turbo_stream.update("new_product", "")
        ]
      end
      format.html { redirect_to @product, notice: "Product was successfully created." }
    end
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit
  end

 def update
  quantity_to_sell = params[:quantity_to_sell].to_i

  if quantity_to_sell > @product.quantity
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("flash-messages",
          partial: "shared/flash_message",
          locals: { type: "alert", message: "Cannot sell more than available stock" }
        )
      end
      format.html { redirect_to products_url, alert: "Cannot sell more than available stock" }
    end
    return
  end

  new_quantity = @product.quantity - quantity_to_sell

  if @product.update(quantity: new_quantity)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append("flash-messages",
            partial: "shared/flash_message",
            locals: { type: "notice", message: "Successfully sold #{quantity_to_sell} units" }
          ),
          turbo_stream.replace(@product),
          turbo_stream.replace("notification_count",
            partial: "shared/notification_count",
            locals: { count: Notification.unread.count }
          )
        ]
      end
      format.html { redirect_to @product, notice: "Successfully sold #{quantity_to_sell} units" }
    end
  else
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
  @product.destroy
  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.append("flash-messages", partial: "shared/flash_message", locals: { type: "notice", message: "Product was successfully deleted." }),
        turbo_stream.remove(@product)
      ]
    end
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

  def close_edit
  @product = Product.find(params[:id])
  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to products_url }
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
