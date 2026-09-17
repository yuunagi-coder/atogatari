FactoryBot.define do
  factory :record do
    spot_name { "test" }
    created_at { "2026-09-06 08:49:11.419241000 +900"}
    latitude: 0.35628471e2
    longitude: 0.13973876e3
    memo: "test"
    association :user 
  end
end
