class User < ApplicationRecord
  has_secure_password
  validates :username, uniqueness: { case_sensitive: true }

  has_many :followers, class_name:  "Following", foreign_key: "follower_id", dependent: :destroy

  has_many :following, class_name: "Following", foreign_key: "followed_id", dependent: :destroy
end
