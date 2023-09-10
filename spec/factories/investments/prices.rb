FactoryBot.define do
  factory :price, class: 'Investments::Price' do
    date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    value_cents { rand(1..100) }

    trait :for_stock do
      association :negotiable, factory: :stock
    end
  end
end
