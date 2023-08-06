FactoryBot.define do
  factory :category, class: Category do
    name { Faker::Commerce.department }
    user { create(:user) }
  end
end
