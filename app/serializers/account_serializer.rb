class AccountSerializer < ActiveModel::Serializer
  attributes :id, :email, :status
end
