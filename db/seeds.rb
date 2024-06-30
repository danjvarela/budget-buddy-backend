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
  expense_categories = ["Household", "Transportation", "Food", "Health", "Social Life", "Others"].map do |name|
    user.categories.create! name: name, category_type: "expense"
  end

  income_categories = ["Salary", "Petty Cash", "Allowance", "Others"].map do |name|
    user.categories.create! name: name, category_type: "income"
  end

  financial_accounts = ["Cash", "Savings Account", "Digital Wallet"].map do |name|
    user.financial_accounts.create! name: name
  end

  100.times do |n|
    user.transactions.create({
      financial_account: financial_accounts.sample,
      category: expense_categories.sample,
      description: "Expense Transaction #{n}",
      amount: [100, 200, 300, 500, 1000].sample,
      transaction_type: "expense",
      date: DateTime.now - n.days
    })
  end
  puts "Generated expense transactions for #{user.email}"

  10.times do |n|
    user.transactions.create({
      financial_account: financial_accounts.sample,
      category: income_categories.sample,
      description: "Income Transaction #{n}",
      amount: [35000, 10000, 20000].sample,
      transaction_type: "income",
      date: DateTime.now - n.days
    })
  end
  puts "Generated income transactions for #{user.email}"

  5.times do |n|
    user.transactions.create({
      from_financial_account: financial_accounts.first,
      to_financial_account: financial_accounts.second,
      description: "Transaction #{n}",
      amount: [100, 200, 300].sample,
      transaction_type: "transfer",
      date: DateTime.now - n.days
    })
  end
  puts "Generated transfer transactions for #{user.email}"
end

user = User.create!(email: "example@email.com", password: "123qwe123")
user.verified!

user2 = User.create!(email: "example01@email.com", password: "123qwe123")
user2.verified!

generate_records_for user
generate_records_for user2
