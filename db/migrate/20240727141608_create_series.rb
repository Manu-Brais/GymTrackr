class CreateSeries < ActiveRecord::Migration[7.1]
  def change
    create_table :series, id: :uuid, default: "gen_random_uuid()" do |t|
      t.integer :rest_in_minutes
      t.integer :rounds
      t.integer :min_reps
      t.integer :max_reps
      t.integer :max_rir
      t.integer :min_rir
      t.references :exercise, null: false, foreign_key: true, type: :uuid
      t.references :routine_day, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
