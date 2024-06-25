class FinancialAccount < ApplicationRecord
  belongs_to :account

  validates :name, presence: true
  validates :amount, presence: true
end
