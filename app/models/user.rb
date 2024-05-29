class User < ApplicationRecord
  has_secure_password

  belongs_to :authenticatable, polymorphic: true

  # TODO - Add email validation (pattern)
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}

  def coach?
    authenticatable_type == "Coach"
  end

  def client?
    authenticatable_type == "Client"
  end
end
