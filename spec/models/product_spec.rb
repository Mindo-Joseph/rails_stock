require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
  subject(:product) {
    build(:product,
      name: "Test Product",
      price: 100,
      quantity: 10,
      sku: "TEST-001"
    )
  }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:sku) }

  it { should validate_uniqueness_of(:sku).case_insensitive }

  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe 'scopes' do
    let!(:in_stock_product) { create(:product, quantity: 15, low_stock_threshold: 10) }
    let!(:low_stock_product) { create(:product, :low_stock) }
    let!(:out_of_stock_product) { create(:product, :out_of_stock) }

    describe '.low_stock' do
      it 'returns products with quantity below or equal to threshold' do
        expect(Product.low_stock).to include(low_stock_product)
        expect(Product.low_stock).not_to include(in_stock_product)
      end
    end

    describe '.search' do
      it 'finds products by name' do
        expect(Product.search(in_stock_product.name)).to include(in_stock_product)
      end

      it 'finds products by SKU' do
        expect(Product.search(in_stock_product.sku)).to include(in_stock_product)
      end
    end
  end

  describe '#low_stock?' do
    it 'returns true when quantity is below threshold' do
      product = build(:product, quantity: 5, low_stock_threshold: 10)
      expect(product).to be_low_stock
    end

    it 'returns false when quantity is above threshold' do
      product = build(:product, quantity: 15, low_stock_threshold: 10)
      expect(product).not_to be_low_stock
    end
  end
end
