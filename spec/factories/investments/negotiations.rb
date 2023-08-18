FactoryBot.define do
  factory :negotiation, class: 'Investments::Negotiation' do
    kind { %w[Buy Sell].sample }
    date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    invested_cents { rand(1..100) }
    shares { rand(1..100) }
  end
end
