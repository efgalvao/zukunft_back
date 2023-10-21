FactoryBot.define do
  factory :dividend, class: Investments::Stock::Dividend do
    date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    value_cents { rand(1.0..1000.0).round(2) }
    stock { create(:stock) }
  end
end
