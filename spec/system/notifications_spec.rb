require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "low stock notifications" do
    let!(:product) { create(:product, quantity: 15, low_stock_threshold: 10) }

    it "creates notification when stock goes below threshold" do
      expect {
        product.update(quantity: 5)
      }.to change(Notification, :count).by(1)

      notification = Notification.last
      expect(notification.title).to eq("Low Stock Alert")
      expect(notification.message).to include(product.name)
    end

    it "shows notification in the UI" do
      product.update(quantity: 5)
      visit products_path
      
      within(".notification-bell") do
        expect(page).to have_content("1")
      end
    end
  end
end