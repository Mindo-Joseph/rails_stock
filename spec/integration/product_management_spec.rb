require 'rails_helper'

RSpec.describe "Product Management", type: :request do
  describe "stock management" do
    let(:product) { create(:product, quantity: 20, low_stock_threshold: 10) }

    it "creates notification when stock goes below threshold" do
      expect {
        patch product_path(product), params: { product: { quantity: 5 } }
      }.to change(Notification, :count).by(1)
    end

    it "updates stock level" do
      patch product_path(product), params: { product: { quantity: 15 } }
      expect(product.reload.quantity).to eq(15)
    end
  end

  describe "search and filtering" do
    let!(:in_stock_product) { create(:product, name: "In Stock Item") }
    let!(:low_stock_product) { create(:product, :low_stock, name: "Low Stock Item") }

    it "filters products by status" do
      get products_path, params: { status: 'low_stock' }
      expect(response.body).to include(low_stock_product.name)
      expect(response.body).not_to include(in_stock_product.name)
    end

    it "searches products by name" do
      get products_path, params: { query: "Low Stock" }
      expect(response.body).to include(low_stock_product.name)
      expect(response.body).not_to include(in_stock_product.name)
    end
  end
end