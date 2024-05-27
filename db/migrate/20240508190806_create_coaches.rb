class CreateCoaches < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :name
      t.string :surname
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
