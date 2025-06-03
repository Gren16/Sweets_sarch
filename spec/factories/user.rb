FactoryBot.define do
  factory :user do
    name { "らんてくん" }
    sequence(:email) { |n| "runteq_#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
