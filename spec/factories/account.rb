FactoryBot.define do
  sequence(:account_email) { |n| "email#{n}@example.com" }

  factory :account do
    email { generate :account_email }
    password { "123qwe123" }
    status { "verified" }
  end
end
