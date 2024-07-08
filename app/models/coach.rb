class Coach < ApplicationRecord
  has_one :user, as: :authenticatable, dependent: :destroy
  has_one :referral_token, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :exercises, dependent: :destroy

  has_one_attached :avatar

  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true) if avatar.attached?
  end
end
