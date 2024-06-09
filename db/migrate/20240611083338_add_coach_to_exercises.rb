# frozen_string_literal: true

class AddCoachToExercises < ActiveRecord::Migration[7.1]
  def change
    add_reference :exercises, :coach, type: :uuid, foreign_key: true, null: false
  end
end
