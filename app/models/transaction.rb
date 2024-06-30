class Transaction < ApplicationRecord
  before_save :set_nil_attributes
  belongs_to :account
  belongs_to :category, optional: true
  belongs_to :financial_account, optional: true
  belongs_to :from_financial_account, foreign_key: "from_financial_account_id", inverse_of: "transfer_transactions_as_origin", optional: true, class_name: "FinancialAccount"
  belongs_to :to_financial_account, foreign_key: "to_financial_account_id", inverse_of: "transfer_transactions_as_receiver", optional: true, class_name: "FinancialAccount"

  enum :transaction_type, expense: 1, income: 2, transfer: 3

  validates :category, presence: true, if: -> { income? || expense? }
  validates :from_financial_account, presence: true, if: -> { transfer? }
  validates :to_financial_account, presence: true, if: -> { transfer? }
  validates :financial_account, presence: true, if: -> { income? || expense? }
  validates :date, presence: true
  validate :ensure_consistent_type

  private

  def set_nil_attributes
    if transfer?
      self.category = nil
    end

    if income? || expense?
      self.from_financial_account = nil
      self.to_financial_account = nil
    end
  end

  def ensure_consistent_type
    if (income? || expense?) && category.present? && (category.category_type != transaction_type)
      errors.add(:category_id, "must have the same type as the transaction")
    end
  end
end
