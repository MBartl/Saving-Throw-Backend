class Spellcasting < ApplicationRecord
  belongs_to :player_class

  serialize :info, JSON
end
