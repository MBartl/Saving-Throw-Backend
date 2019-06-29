class Proficiency < ApplicationRecord
  has_many :class_proficiency_choices, dependent: :destroy
end
