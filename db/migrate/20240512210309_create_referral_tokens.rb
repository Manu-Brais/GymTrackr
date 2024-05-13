class CreateReferralTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :referral_tokens, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
