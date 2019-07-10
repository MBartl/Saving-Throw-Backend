class MessageSerializer < ActiveModel::Serializer
  attributes :id, :chat, :user, :text, :created_at
end
