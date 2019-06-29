class Subclass < ApplicationRecord
  belongs_to :player_class

  has_many :class_spells, dependent: :destroy
  has_many :characters, dependent: :destroy
end
