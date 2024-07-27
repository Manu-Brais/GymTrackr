class CreateRoutines < ActiveRecord::Migration[7.1]
  def change
    create_table :routines, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :days_per_week
      t.references :client, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
