module ProductsHelper
  def stock_status_badge(product)
    if product.quantity.zero?
      content_tag(:span, "Out of Stock", class: "px-2 py-1 text-xs font-medium text-red-700 bg-red-100 rounded-full")
    elsif product.low_stock?
      content_tag(:span, "Low Stock", class: "px-2 py-1 text-xs font-medium text-yellow-700 bg-yellow-100 rounded-full")
    else
      content_tag(:span, "In Stock", class: "px-2 py-1 text-xs font-medium text-green-700 bg-green-100 rounded-full")
    end
  end

  def format_price(price)
    number_to_currency(price, unit: "$")
  end
end
