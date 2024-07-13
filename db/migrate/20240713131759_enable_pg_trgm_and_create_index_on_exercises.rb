class EnablePgTrgmAndCreateIndexOnExercises < ActiveRecord::Migration[7.1]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
    add_index :exercises, :title, using: :gin, opclass: :gin_trgm_ops, name: "trgm_idx_exercises_on_title"
  end

  def down
    remove_index :exercises, name: "trgm_idx_exercises_on_title"
    execute "DROP EXTENSION IF EXISTS pg_trgm;"
  end
end
