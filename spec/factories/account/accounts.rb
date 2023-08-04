FactoryBot.define do
  factory :account, class: Account::Account do
    name { 'Account Name' }
    user { create(:user) }
    balance_cents { 12_345 }
    kind { 'savings' }

    trait :broker do
      kind { 'broker' }
    end

    trait :card do
      kind { 'card' }
    end
  end
end
