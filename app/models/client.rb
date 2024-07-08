class Client < ApplicationRecord
  has_one :user, as: :authenticatable, dependent: :destroy
  belongs_to :coach

  has_one_attached :avatar

  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true) if avatar.attached?
  end
end
