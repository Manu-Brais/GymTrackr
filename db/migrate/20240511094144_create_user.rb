class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid, default: "gen_random_uuid()" do |t|
      t.string :email, null: false, index: {unique: true}
      t.string :password_digest, null: false

      t.string :authenticatable_type
      t.string :authenticatable_id

      t.timestamps
    end

    add_index :users, [:authenticatable_type, :authenticatable_id]
  end
end
