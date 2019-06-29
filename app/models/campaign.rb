class Campaign < ApplicationRecord
  has_many :dm_campaigns, dependent: :destroy
  has_many :users, through: :dm_campaigns

  has_many :campaign_characters, dependent: :destroy
  has_many :characters, through: :campaign_characters
end
