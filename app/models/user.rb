class User < ApplicationRecord
  has_secure_password

  belongs_to :authenticatable, polymorphic: true
  has_many :referral_tokens

  # TODO - Add email validation (pattern)
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}
end
