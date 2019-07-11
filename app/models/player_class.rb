class PlayerClass < ApplicationRecord
  has_many :subclasses, dependent: :destroy
  has_many :class_spells, dependent: :destroy

  has_many :class_proficiency_choices, dependent: :destroy
  has_many :class_proficiencies, dependent: :destroy

  has_many :proficiencies, through: :class_proficiencies

  has_many :spellcastings
end
