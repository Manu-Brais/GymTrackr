module Types
  class ExerciseType < BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :video_status, String, null: false
    field :video_url, String, null: true

    def video_url
      Rails.application
        .routes
        .url_helpers
        .rails_blob_path(
          object.video,
          only_path: true
        )
    end
  end
end
