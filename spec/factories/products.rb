FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyText" }
    price { "9.99" }
    quantity { 1 }
    low_stock_threshold { 1 }
    sku { "MyString" }
  end
end
