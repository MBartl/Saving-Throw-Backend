class ChatSerializer < ActiveModel::Serializer
  attributes :id, :campaign_id
  has_many :messages
end
