class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :biography, :level, :player_class, :race, :subclass, :subrace

  belongs_to :user
  has_many :character_campaigns

  has_many :ability_scores
  has_many :skills
  has_many :character_proficiency_choices
  has_many :character_proficiencies
  has_many :character_spells
end
