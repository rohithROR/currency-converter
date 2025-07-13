FactoryBot.define do
  factory :conversion do
    source_currency { "USD" }
    target_currency { "EUR" }
    source_amount { 100.0 }
    target_amount { 85.0 }
    rate { 0.85 }
  end
end
