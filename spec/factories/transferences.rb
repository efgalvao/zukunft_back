FactoryBot.define do
  factory :transference do
    date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    value_cents { Faker::Number.number(digits: 5) }
    user { create(:user) }
    sender_id { create(:account).id }
    receiver_id { create(:account).id }
  end
end
