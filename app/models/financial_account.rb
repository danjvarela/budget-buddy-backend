class FinancialAccount < ApplicationRecord
  belongs_to :account

  validates :name, presence: true, uniqueness: {scope: :account_id, case_sensitive: false}
  validates :amount, presence: true
end
