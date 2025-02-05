require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    let!(:product) { create(:product) }

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    context 'with search parameter' do
      it 'filters products by search term' do
        get :index, params: { query: product.name }
        expect(assigns(:products)).to include(product)
      end
    end

    context 'with status filter' do
      let!(:low_stock_product) { create(:product, :low_stock) }

      it 'filters products by status' do
        get :index, params: { status: 'low_stock' }
        expect(assigns(:products)).to include(low_stock_product)
        expect(assigns(:products)).not_to include(product)
      end
    end
  end

  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'returns a successful response' do
      get :show, params: { id: product.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:product) }

    context 'with valid params' do
      it 'creates a new product' do
        expect {
          post :create, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'does not create a product' do
        expect {
          post :create, params: { product: { name: '' } }
        }.not_to change(Product, :count)
      end
    end
  end

  describe 'GET #export' do
    before { create_list(:product, 3) }

    it 'returns CSV file' do
      get :export, format: :csv
      expect(response.header['Content-Type']).to include 'text/csv'
    end

    it 'returns Excel file' do
      get :export, format: :xlsx
      expect(response.header['Content-Type']).to include 'spreadsheet'
    end
  end
end
