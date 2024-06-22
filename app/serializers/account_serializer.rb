class AccountSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :status
end
