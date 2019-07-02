class Character < ApplicationRecord
  belongs_to :user
  belongs_to :player_class
  belongs_to :subclass
  belongs_to :race
  belongs_to :subrace, optional: true

  has_many :campaign_characters, dependent: :destroy
  has_many :campaigns, through: :campaign_characters

  has_many :ability_scores, dependent: :destroy
  has_many :skills, dependent: :destroy

  has_many :character_proficiency_choices, dependent: :destroy
end
