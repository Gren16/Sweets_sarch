FactoryBot.define do
  factory :store do
    name { "スイーツカフェ" }
    address { "東京都渋谷区1-1-1" }
    phone_number { "03-1234-5678" }
    place_id { 1 }
    latitude { 35.6895 }
    longitude { 139.6917 }
  end
end
