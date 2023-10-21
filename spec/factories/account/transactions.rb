FactoryBot.define do
  factory :transaction, class: Account::Transaction do
    account { create(:account) }
    category_id { create(:category).id }
    value_cents { rand(1.0..1000.0).round(2) }
    kind { 'income' }
    title { Faker::Commerce.material }
    date { Time.zone.today }
  end
end
