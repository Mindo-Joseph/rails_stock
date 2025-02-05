FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    sequence(:sku) { |n| "SKU-#{n}" }
    description { "A sample product description" }
    price { 99.99 }
    quantity { 20 }
    low_stock_threshold { 10 }

    trait :low_stock do
      quantity { 5 }
    end

    trait :out_of_stock do
      quantity { 0 }
    end
  end
end
