class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :surname
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
