class CharacterSpell < ApplicationRecord
  belongs_to :character
  belongs_to :spells
end
