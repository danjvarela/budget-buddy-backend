# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def generate_records_for(user)
  ["Household", "Transportation", "Food", "Health", "Social Life", "Others"].each do |name|
    user.categories.create name: name, category_type: "expense"
  end

  ["Salary", "Petty Cash", "Allowance", "Others"].each do |name|
    user.categories.create name: name, category_type: "income"
  end

  ["Cash", "Savings Account", "Digital Wallet"].each do |name|
    user.financial_accounts.create name: name
  end

  user.transactions.create transaction_type: "expense", amount: 100, description: "Test Transaction", category: user.categories.expense.first, financial_account: user.financial_accounts.first, date: DateTime.now
  user.transactions.create transaction_type: "income", amount: 100, description: "Test Transaction", category: user.categories.income.first, financial_account: user.financial_accounts.first, date: DateTime.now
  user.transactions.create transaction_type: "transfer", amount: 100, description: "Test Transaction", from_financial_account: user.financial_accounts.first, to_financial_account: user.financial_accounts.second, date: DateTime.now
end

user = User.create!(email: "example@email.com", password: "123qwe123")
user.verified!

user2 = User.create!(email: "example01@email.com", password: "123qwe123")
user2.verified!

generate_records_for user
generate_records_for user2
