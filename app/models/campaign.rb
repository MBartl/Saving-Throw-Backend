class Campaign < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2, errors: "Campaign must have a name at least 2 characters long" }
  validates :max_players, numericality: { only_integer: true, less_than_or_equal_to: 50, errors: "Campaign must have a set number of max players under 50" }

  has_many :dm_campaigns, dependent: :destroy
  has_many :users, through: :dm_campaigns

  has_many :campaign_characters, dependent: :destroy
  has_many :characters, through: :campaign_characters

  has_many :chats, dependent: :destroy
end
