FactoryBot.define do
  factory :account, class: Account::Account do
    name { Faker::Company.name }
    user { create(:user) }
    balance_cents { 100 }
    kind { 'savings' }

    trait :broker do
      kind { 'broker' }
    end

    trait :card do
      kind { 'card' }
    end
  end
end
