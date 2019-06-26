class CharacterProficiencyChoice < ApplicationRecord
  belongs_to :character
  belongs_to :proficiency
end
