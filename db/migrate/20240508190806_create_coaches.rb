class CreateCoaches < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :password_digest
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
