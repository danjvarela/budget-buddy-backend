class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :status
end
