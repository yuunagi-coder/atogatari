FactoryBot.define do
  factory :user do
    name { "test" }
    sequence(:email_address){ |n| "test#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
