FactoryBot.define do
  factory :notification do
    title { "MyString" }
    message { "MyText" }
    status { 1 }
    product { nil }
    read_at { "2025-02-04 09:49:02" }
  end
end
