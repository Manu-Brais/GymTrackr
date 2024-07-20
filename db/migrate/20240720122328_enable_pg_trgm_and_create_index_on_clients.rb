class EnablePgTrgmAndCreateIndexOnClients < ActiveRecord::Migration[7.1]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    add_index :clients, :name, using: :gin, opclass: :gin_trgm_ops, name: "trgm_idx_clients_on_name"
    add_index :clients, :surname, using: :gin, opclass: :gin_trgm_ops, name: "trgm_idx_clients_on_surname"
  end

  def down
    remove_index :clients, name: "trgm_idx_clients_on_name"
    remove_index :clients, name: "trgm_idx_clients_on_surname"
    execute "DROP EXTENSION IF EXISTS pg_trgm;"
  end
end
