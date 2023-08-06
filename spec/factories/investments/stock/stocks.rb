FactoryBot.define do
  factory :stock, class: Investments::Stock::Stock do
    ticker { Faker::Finance.ticker }
    invested_value_cents { rand(1..100) }
    current_value_cents { rand(1..100) }
    current_total_value_cents { rand(1..100) }
    shares_total { rand(1..100) }
    account { create(:account) }
  end
end
