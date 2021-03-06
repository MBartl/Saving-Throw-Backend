class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: { case_sensitive: true }
  validates :email, allow_blank: true, length: { maximum: 75 }, format: { with: URI::MailTo::EMAIL_REGEXP, errors: "Email address must be valid" }

  has_many :followers, class_name:  "Following", foreign_key: "follower_id", dependent: :destroy

  has_many :followings, class_name: "Following", foreign_key: "following_id", dependent: :destroy

  has_many :characters, dependent: :destroy
  has_many :dm_campaigns, dependent: :destroy
end
