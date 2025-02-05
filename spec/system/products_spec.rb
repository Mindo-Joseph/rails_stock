require 'rails_helper'

RSpec.describe "Products", type: :system do
  include ActionView::RecordIdentifier
  before do
    driven_by(:rack_test)
  end

  describe "index page" do
    let!(:product) { create(:product) }
    let!(:low_stock_product) { create(:product, :low_stock) }

    it "displays all products" do
      visit products_path
      expect(page).to have_content(product.name)
      expect(page).to have_content(low_stock_product.name)
    end

    it "filters products by status" do
      visit products_path
      select "Low Stock", from: "status"
      click_button "Search"

      expect(page).to have_content(low_stock_product.name)
      expect(page).not_to have_content(product.name)
    end

    it "searches products by name" do
      visit products_path
      fill_in "query", with: product.name
      click_button "Search"

      expect(page).to have_content(product.name)
    end
  end

  describe "creating a product" do
    it "creates a new product with valid data" do
      visit new_product_path

      fill_in "product[name]", with: "New Product"
      fill_in "product[sku]", with: "TEST-001"
      fill_in "product[description]", with: "A test product"
      fill_in "product[price]", with: "99.99"
      fill_in "product[quantity]", with: "10"
      fill_in "product[low_stock_threshold]", with: "5"

      click_button "Create Product"

      expect(page).to have_content("Product was successfully created")
      expect(page).to have_content("New Product")
    end

    it "shows validation errors with invalid data" do
      visit new_product_path
      click_button "Create Product"

      expect(page).to have_content("can't be blank")
    end
  end

  describe "updating a product" do
    let!(:product) { create(:product) }

    it "updates product with valid data" do
      visit edit_product_path(product)

      fill_in "product[name]", with: "Updated Name"
      click_button "Update Product"

      expect(page).to have_content("Product was successfully updated")
      expect(page).to have_content("Updated Name")
    end
  end

 describe "stock management" do
  let!(:product) { create(:product, quantity: 20, low_stock_threshold: 10) }

  it "updates stock level in real-time" do
    visit products_path

    expect(page).to have_content(product.name)
    expect(page).to have_content("In Stock")

    find("input[name='product[quantity]']").set(5)
    click_button "Update"

    expect(page).to have_content("Low Stock")
  end
end

  describe "exporting products" do
    before { create_list(:product, 3) }

    it "exports to CSV" do
      visit products_path
      click_link "CSV"

      expect(page.response_headers['Content-Type']).to include 'text/csv'
    end

    it "exports to Excel" do
      visit products_path
      click_link "Excel"

      expect(page.response_headers['Content-Type']).to include 'spreadsheet'
    end
  end
end
