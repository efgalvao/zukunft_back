FactoryBot.define do
  factory :transference do
    date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    value_cents { rand(1.0..100_00.0).round(2) }
    user { create(:user) }
    sender_id { create(:account).id }
    receiver_id { create(:account).id }
  end
end
