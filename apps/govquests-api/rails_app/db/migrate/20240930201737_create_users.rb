class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :user_id, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :user_type, null: false, default: "non_delegate"
      t.jsonb :settings, default: {}
      t.jsonb :wallets, default: []
      t.jsonb :sessions, default: []
      t.jsonb :quests_progress, default: {}
      t.jsonb :activity_log, default: []
      t.timestamps
    end

    create_table :user_sessions do |t|
      t.string :user_id, null: false
      t.string :session_token, null: false
      t.datetime :logged_in_at, null: false
      t.datetime :logged_out_at
      t.timestamps
    end

    create_table :user_rewards do |t|
      t.string :user_id, null: false
      t.string :reward_id, null: false
      t.string :status, default: "pending"
      t.timestamps
    end

    add_index :user_sessions, :user_id
    add_index :user_rewards, [ :user_id, :reward_id ], unique: true
  end
end
