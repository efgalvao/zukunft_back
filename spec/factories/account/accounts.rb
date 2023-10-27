FactoryBot.define do
  factory :account, class: Account::Account do
    name { Faker::Company.unique.name }
    user { create(:user) }
    balance_cents { rand(1.0..1000.0).round(2) }
    kind { 'savings' }

    trait :broker do
      kind { 'broker' }
    end

    trait :card do
      kind { 'card' }
    end
  end
end
