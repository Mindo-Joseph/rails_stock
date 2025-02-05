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
    number_to_currency(price, unit: "KES")
  end

  def stock_status_options
    [
      ['All Status', ''],
      ['In Stock', 'in_stock'],
      ['Low Stock', 'low_stock'],
      ['Out of Stock', 'out_of_stock']
    ]
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
end
