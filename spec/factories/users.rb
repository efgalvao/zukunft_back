FactoryBot.define do
  factory :user, class: 'User' do
    name { 'User Name' }
    username { 'User username' }
    email { 'user@email.com' }
    password { '123456' }
  end
end
