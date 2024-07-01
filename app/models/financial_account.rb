class FinancialAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :nullify
  has_many :transfer_transactions_as_origin, foreign_key: "from_financial_account_id", class_name: "Transaction", dependent: :nullify, inverse_of: "from_financial_account"
  has_many :transfer_transactions_as_receiver, foreign_key: "to_financial_account_id", class_name: "Transaction", dependent: :nullify, inverse_of: "to_financial_account"

  validates :name, presence: true, uniqueness: {scope: :user_id, case_sensitive: false}

  def current_balance
    total_income = transactions.income.reduce(0) { |sum, transaction| sum + transaction.amount }
    total_expense = transactions.expense.reduce(0) { |sum, transaction| sum + transaction.amount }
    total_transfer_as_origin = transfer_transactions_as_origin.reduce(0) { |sum, transaction| sum + transaction.amount }
    total_transfer_as_receiver = transfer_transactions_as_receiver.reduce(0) { |sum, transaction| sum + transaction.amount }
    total_income + total_transfer_as_receiver - total_expense - total_transfer_as_origin
  end
end
