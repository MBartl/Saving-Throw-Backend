class ClassProficiencyChoice < ApplicationRecord
  belongs_to :player_class
  belongs_to :proficiency
end
