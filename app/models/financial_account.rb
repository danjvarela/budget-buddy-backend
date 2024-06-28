class FinancialAccount < ApplicationRecord
  has_many :expenses, dependent: :destroy
  belongs_to :account

  validates :name, presence: true, uniqueness: {scope: :account_id, case_sensitive: false}
end
