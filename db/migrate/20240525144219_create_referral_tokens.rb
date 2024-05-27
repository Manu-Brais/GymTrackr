class CreateReferralTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :referral_tokens, id: :uuid, default: "gen_random_uuid()" do |t|
      t.uuid :coach_id, null: false
      t.timestamps
    end

    add_index :referral_tokens, :coach_id
    add_foreign_key :referral_tokens, :coaches, column: :coach_id
  end
end
