require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:notification) { create(:notification) }

  describe "GET /mark_as_read" do
    it "marks notification as read" do
      post mark_as_read_notification_path(notification)
      expect(response).to redirect_to(notifications_path)
    end
  end
end
