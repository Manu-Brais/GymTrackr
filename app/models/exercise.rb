class Exercise < ApplicationRecord
  after_update :notify_status_change, if: :saved_change_to_video_status?
  after_destroy_commit { video.attachment&.purge }

  has_one_attached :video, dependent: :purge
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

  private

  def notify_status_change
    GymTrackrSchema.subscriptions.trigger(
      :exercise_status_changed, {exercise_id: id}, self
    )
  end
end
