# t.references :account, null: false, foreign_key: true
# t.string :name, null: false
# t.text :description
# t.float :amount, null: false

FactoryBot.define do
  sequence(:financial_account_name) { |n| "financial_account#{n}" }

  factory :financial_account do
    account
    name { generate :financial_account_name }
    amount { 0.0 }
  end
end
