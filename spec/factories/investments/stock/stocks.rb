FactoryBot.define do
  factory :stock, class: Investments::Stock::Stock do
    ticker { Faker::Finance.ticker }
    invested_value_cents { rand(1.0..1000.0).round(2) }
    current_value_cents { rand(1.0..1000.0).round(2) }
    current_total_value_cents { rand(1.0..1000.0).round(2) }
    shares_total { rand(1..100) }
    account { create(:account) }
  end
end
