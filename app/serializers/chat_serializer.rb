class ChatSerializer < ActiveModel::Serializer
  attributes :id, :campaign
  has_many :messages

  def campaign
    campaign = self.object.campaign
    campaign =
    { id: campaign.id, name: campaign.name, players: campaign.characters.map(&:user).uniq, open_invite: campaign.open_invite }
  end
end
