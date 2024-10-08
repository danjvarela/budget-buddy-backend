class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :transaction_type, :date, :amount, :description
  belongs_to :category, if: -> { object.income? || object.expense? }
  belongs_to :financial_account, if: -> { object.income? || object.expense? }, class_name: "FinancialAccount"
  belongs_to :from_financial_account, if: -> { object.transfer? }, class_name: "FinancialAccount"
  belongs_to :to_financial_account, if: -> { object.transfer? }, class_name: "FinancialAccount"
end
