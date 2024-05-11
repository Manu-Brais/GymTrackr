class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false

      t.string :authenticatable_type
      t.bigint :authenticatable_id

      t.timestamps
    end

    add_index :users, [:authenticatable_type, :authenticatable_id]
  end
end
