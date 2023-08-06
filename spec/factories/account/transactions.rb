FactoryBot.define do
  factory :transaction, class: Account::Transaction do
    account { create(:account) }
    category_id { create(:category).id }
    value_cents { 1000 }
    kind { 'income' }
    title { Faker::Commerce.material }
    date { Time.zone.today }
  end
end
