class CreateExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :exercises, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :title
      t.text :description
      t.string :video_status

      t.timestamps
    end
  end
end
