class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :name
      t.string :surname
      t.string :phone
      t.string :address

      t.timestamps
    end

    add_index :clients, :coach_id
  end
end
