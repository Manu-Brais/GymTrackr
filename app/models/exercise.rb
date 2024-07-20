class Exercise < ApplicationRecord
  include PgSearch::Model

  after_update :notify_status_change, if: :saved_change_to_video_status?
  after_destroy_commit { video.attachment&.purge }

  has_one_attached :video, dependent: :purge
  has_one_attached :thumbnail
  belongs_to :coach

  validates :title, presence: true
  validates :video_status, inclusion: {in: %w[initialized enqueued processing processed failed]}

  enum video_status: {
    initialized: "initialized",
    enqueued: "enqueued",
    processing: "processing",
    processed: "processed",
    failed: "failed"
  }

  pg_search_scope :fuzzy_search,
    against: [:title],
    using: {
      tsearch: { prefix: true },
      trigram: {
        threshold: 0.3
      }
    }

  def video_url
    Rails.application.routes.url_helpers.rails_blob_url(video, only_path: true) if video.attached?
  end

  def video_thumbnail_url
    Rails.application.routes.url_helpers.rails_blob_url(thumbnail, only_path: true) if thumbnail.attached?
  end

  private

  def notify_status_change
    GymTrackrSchema.subscriptions.trigger(
      :exercise_status_changed, {exercise_id: id}, self
    )
  end
end
