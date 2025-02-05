class StockManager
  def self.update_stock(product, quantity_change)
    new(product).update_stock(quantity_change)
  end

  def initialize(product)
    @product = product
  end

  def update_stock(quantity_change)
    new_quantity = @product.quantity + quantity_change

    if new_quantity < 0
      false
    else
      @product.update(quantity: new_quantity)
    end
  end
end
