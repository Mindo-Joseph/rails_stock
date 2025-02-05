require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:product) { create(:product) }

  describe "GET /index" do
    it "returns http success" do
      get products_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get product_path(product)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get edit_product_path(product)
      expect(response).to have_http_status(:success)
    end
  end
end
