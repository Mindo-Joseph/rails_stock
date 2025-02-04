class Product < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, maximum: 255 }
  validates :price, presence: true,
                   numericality: { greater_than_or_equal_to: 0, less_than: 1_000_000 }
  validates :quantity, presence: true,
                      numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :low_stock_threshold, presence: true,
                                numericality: { only_integer: true, greater_than: 0 }
  validates :sku, presence: true,
                 uniqueness: true,
                 format: { with: /\A[A-Z0-9-]+\z/, message: "only allows uppercase letters, numbers and hyphens" }

  scope :low_stock, -> { where('quantity <= low_stock_threshold') }
  scope :in_stock, -> { where('quantity > 0') }
  scope :out_of_stock, -> { where(quantity: 0) }

  def low_stock?
    quantity <= low_stock_threshold
  end

  def out_of_stock?
    quantity.zero?
  end

  def sku=(value)
    super(value.to_s.upcase)
  end
end
