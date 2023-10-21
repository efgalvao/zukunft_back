FactoryBot.define do
  factory :negotiation, class: 'Investments::Negotiation' do
    kind { %w[Buy Sell].sample }
    date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    invested_cents { rand(1.0..1000.0).round(2) }
    shares { rand(1..100) }

    trait :for_stock do
      association :negotiable, factory: :stock
    end
  end
end
