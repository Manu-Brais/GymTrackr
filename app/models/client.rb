class Client < ApplicationRecord
  include PgSearch::Model

  belongs_to :coach
  has_one :user, as: :authenticatable, dependent: :destroy
  has_one_attached :avatar
  has_many :routines, dependent: :destroy

  pg_search_scope :fuzzy_search,
    against: [:name, :surname],
    using: {
      tsearch: {prefix: true},
      trigram: {
        threshold: 0.3
      }
    }

  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true) if avatar.attached?
  end
end
