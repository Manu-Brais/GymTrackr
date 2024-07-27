class CreateRoutineDays < ActiveRecord::Migration[7.1]
  def change
    create_table :routine_days, id: :uuid, default: "gen_random_uuid()" do |t|
      t.integer :order
      t.references :routine, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
