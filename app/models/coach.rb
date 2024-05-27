class Coach < ApplicationRecord
  has_one :user, as: :authenticatable, dependent: :destroy
  has_one :referral_token, dependent: :destroy
  has_many :clients, dependent: :destroy
end
