class Expense < ApplicationRecord
  belongs_to :account
  belongs_to :category
  belongs_to :financial_account

  validates :date, presence: true
end
