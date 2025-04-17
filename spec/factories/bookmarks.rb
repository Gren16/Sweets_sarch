FactoryBot.define do
  factory :bookmark do
    association :user
    association :store
  end
end
