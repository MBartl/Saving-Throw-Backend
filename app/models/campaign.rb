class Campaign < ApplicationRecord
  validates :name, presence: true
  validates :max_players, numericality: { only_integer: true, less_than_or_equal_to: 50 }

  has_many :dm_campaigns, dependent: :destroy
  has_many :users, through: :dm_campaigns

  has_many :campaign_characters, dependent: :destroy
  has_many :characters, through: :campaign_characters
end
