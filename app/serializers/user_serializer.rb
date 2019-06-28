class UserSerializer < ActiveModel::Serializer
  attributes :username, :name, :email, :bio, :age, :location
end
