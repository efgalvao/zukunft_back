FactoryBot.define do
  factory :account, class: Account::Account do
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.planet }
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
