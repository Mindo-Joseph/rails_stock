FactoryBot.define do
  factory :notification do
    title { "Test Notification" }
    message { "This is a test notification" }
    association :product
  end
end
