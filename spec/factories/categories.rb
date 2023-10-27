FactoryBot.define do
  factory :category, class: Category do
    name { Faker::Commerce.unique.department }
    user { create(:user) }
  end
end
