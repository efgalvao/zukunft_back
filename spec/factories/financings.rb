FactoryBot.define do
  factory :financing, class: Financings::Financing do
    name { Faker::Vehicle.make_and_model }
    installments { SecureRandom.random_number(1..360) }
    # installments { 360 }
    borrowed_value_cents { SecureRandom.random_number(1_000..100_000_000) }
    user { create(:user) }
  end
end
