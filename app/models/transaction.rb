class Transaction < ApplicationRecord
  before_save :set_nil_attributes
  belongs_to :account
  belongs_to :category, optional: true
  belongs_to :from_financial_account, foreign_key: "from_financial_account_id", inverse_of: "transactions_as_origin", optional: true, class_name: "FinancialAccount"
  belongs_to :to_financial_account, foreign_key: "to_financial_account_id", inverse_of: "transactions_as_receiver", optional: true, class_name: "FinancialAccount"

  enum :transaction_type, expense: 1, income: 2, transfer: 3

  validates :category, presence: true, if: :should_have_category
  validates :from_financial_account, presence: true, if: :should_have_from_financial_account
  validates :to_financial_account, presence: true, if: :should_have_to_financial_account

  private

  def set_nil_attributes
    if transfer?
      self.category = nil
    end

    if income?
      self.from_financial_account = nil
    end

    if expense?
      self.to_financial_account = nil
    end
  end

  def should_have_category
    income? || expense?
  end

  def should_have_from_financial_account
    expense? || transfer?
  end

  def should_have_to_financial_account
    income? || transfer?
  end
end
