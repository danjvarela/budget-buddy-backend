class FinancialAccount < ApplicationRecord
  belongs_to :account
  has_many :transactions, dependent: :nullify
  has_many :transfer_transactions_as_origin, foreign_key: "from_financial_account_id", class_name: "Transaction", dependent: :nullify, inverse_of: "from_financial_account"
  has_many :transfer_transactions_as_receiver, foreign_key: "to_financial_account_id", class_name: "Transaction", dependent: :nullify, inverse_of: "to_financial_account"

  validates :name, presence: true, uniqueness: {scope: :account_id, case_sensitive: false}
end
