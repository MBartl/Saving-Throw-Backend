class CampaignCharacter < ApplicationRecord
  belongs_to :character
  belongs_to :campaign
end
