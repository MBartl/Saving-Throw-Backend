class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :pictures

  has_many :dm_campaigns
  has_many :users, through: :dm_campaigns

  has_many :campaign_characters
  has_many :characters, through: :campaign_characters
end
