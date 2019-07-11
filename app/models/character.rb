class Character < ApplicationRecord
  validates :name, presence: true
  validates :user, presence: true
  validates :level, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }

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
  has_many :character_proficiencies, dependent: :destroy
  has_many :character_spells, dependent: :destroy

  has_many :class_proficiencies, through: :player_class
  has_many :proficiencies, through: :class_proficiencies
end
