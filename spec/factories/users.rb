FactoryBot.define do
  factory :user, class: 'User' do
    name { Faker::Books::Dune.character }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { '123456' }
  end
end
