FactoryBot.define do
  sequence(:user_email) { |n| "email#{n}@example.com" }
  sequence(:financial_account_name) { |n| "financial_account#{n}" }
  sequence(:category_name) { |n| "category#{n}" }

  factory :user do
    email { generate :user_email }
    password { "123qwe123" }
    status { "verified" }
  end

  factory :financial_account do
    user { association :user }
    name { generate :financial_account_name }
  end

  factory :category do
    category_type { "expense" }
    name { generate :category_name }
    user { association :user }
  end

  factory :transaction do
    user { association :user }
    date { DateTime.now }
    amount { 1.5 }
    description { "Test Transaction" }

    factory :expense_transaction do
      transaction_type { "expense" }
      category { association :category, category_type: transaction_type, user: user }
      financial_account { association :financial_account, user: user }
    end

    factory :income_transaction do
      transaction_type { "income" }
      category { association :category, category_type: transaction_type, user: user }
      financial_account { association :financial_account, user: user }
    end

    factory :transfer_transaction do
      transaction_type { "transfer" }
      from_financial_account { association :financial_account, user: user }
      to_financial_account { association :financial_account, user: user }
    end
  end
end
