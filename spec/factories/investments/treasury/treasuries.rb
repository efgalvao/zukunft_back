FactoryBot.define do
  factory :treasury, class: Investments::Treasury::Treasury do
    name { Faker::Finance.ticker }
    invested_value_cents { rand(1.0..1000.0).round(2) }
    current_value_cents { rand(1.0..1000.0).round(2) }
    account { create(:account) }
    released { false }

    trait :released do
      released { true }
    end
  end
end
