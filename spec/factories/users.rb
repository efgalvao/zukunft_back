FactoryBot.define do
  factory :user, class: 'User' do
    name { Faker::Name.name }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { '123456' }
  end
end
