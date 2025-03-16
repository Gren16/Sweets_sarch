FactoryBot.define do
  factory :user do
    name { "らんてくん" }
    sequence(:email) { |n| "runteq_#{n}@example.com" }
  end
end
