class FinancialAccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :initial_amount, :description, :current_balance
end
