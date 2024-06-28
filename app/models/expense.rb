class Expense < ApplicationRecord
  validate :associated_category_must_be_expense

  belongs_to :account
  belongs_to :category
  belongs_to :financial_account

  validates :date, presence: true

  def associated_category_must_be_expense
    unless category.expense?
      errors.add(:category_id, "must be an expense category type")
    end
  end
end
