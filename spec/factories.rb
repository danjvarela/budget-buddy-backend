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
  end

  factory :category do
    category_type { "expense" }
    name { generate :category_name }
    account { association :account }
  end

  factory :expense do
    account { association :account }
    category { association :category }
    financial_account { association :financial_account }
    amount { 1.5 }
    description { "Some Expense" }
    date { DateTime.new }
  end

  factory :transaction do
    account { association :account }
    from_financial_account { association :financial_account, account: account }
    to_financial_account { association :financial_account, account: account }
    date { DateTime.now }
    amount { 1.5 }
    description { "Test Transaction" }

    factory :expense_transaction do
      transaction_type { "expense" }
      category { association :category, category_type: transaction_type, account: account }
    end

    factory :income_transaction do
      transaction_type { "income" }
      category { association :category, category_type: transaction_type, account: account }
    end

    factory :transfer_transaction do
      transaction_type { "transfer" }
    end
  end
end
