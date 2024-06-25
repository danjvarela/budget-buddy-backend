class FinancialAccountSerializer
  include JSONAPI::Serializer
  set_key_transform :camel_lower
  attributes :id, :name, :amount, :description
  belongs_to :account
end
