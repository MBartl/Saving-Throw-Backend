class Race < ApplicationRecord
  has_many :race_traits, dependent: :destroy
end
