class ClassSpell < ApplicationRecord
  belongs_to :player_class, optional: true
  belongs_to :subclass, optional: true
  belongs_to :spell
end
