class FinancialAccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :amount, :description
end
