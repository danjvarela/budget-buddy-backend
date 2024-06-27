FactoryBot.define do
  sequence(:account_email) { |n| "email#{n}@example.com" }
  sequence(:financial_account_name) { |n| "financial_account#{n}" }
  sequence(:category_name) { |n| "category#{n}" }

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

  factory :category do
    category_type { "expense" }
    name { generate :category_name }
    account { association :account }
  end
end
