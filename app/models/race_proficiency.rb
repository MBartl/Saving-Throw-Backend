class RaceProficiency < ApplicationRecord
  belongs_to :race, optional: true
  belongs_to :subrace, optional: true
  belongs_to :proficiency
end
