FactoryBot.define do
  sequence(:account_email) { |n| "email#{n}@example.com" }
  sequence(:financial_account_name) { |n| "financial_account#{n}" }

  factory :account do
    email { generate :account_email }
    password { "123qwe123" }
    status { "verified" }
  end

  factory :financial_account do
    account { association :account }
    name { generate :financial_account_name }
    amount { 0.0 }
  end
end
