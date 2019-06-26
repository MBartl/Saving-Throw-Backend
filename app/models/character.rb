class Character < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :player_class
  belongs_to :subclass
end
