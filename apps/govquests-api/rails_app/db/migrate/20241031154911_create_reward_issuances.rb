class CreateRewardIssuances < ActiveRecord::Migration[8.1]
  def change
    create_table :reward_issuances do |t|
      t.uuid :pool_id, null: false
      t.uuid :user_id, null: false
      t.datetime :issued_at, null: false
      t.jsonb :claim_metadata, null: false, default: {}
      t.datetime :claim_started_at
      t.datetime :claim_completed_at

      t.timestamps

      t.index [:pool_id, :user_id], unique: true
      t.index :user_id
    end
  end
end
