class Expense < ApplicationRecord
  belongs_to :account
  belongs_to :category
  belongs_to :financial_account

  validates :amount, presence: true
  validates :date, presence: true
end
