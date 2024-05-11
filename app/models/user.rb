class User < ApplicationRecord
  has_secure_password

  belongs_to :authenticatable, polymorphic: true

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}
end
