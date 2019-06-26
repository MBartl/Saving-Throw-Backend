class CharacterSpell < ApplicationRecord
  belongs_to :character
  belongs_to :spell
end
