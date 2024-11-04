class CreateUserGameProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :user_game_profiles do |t|
      t.string :profile_id, null: false, index: {unique: true}
      t.integer :tier, default: 0
      t.integer :track, default: 0
      t.integer :streak, default: 0
      t.integer :score, default: 0
      t.jsonb :badges, default: []
      t.jsonb :unclaimed_tokens, default: {}
      t.jsonb :active_claim, default: nil
      t.timestamps
    end

    create_table :leaderboards, id: false, primary_key: :leaderboard_id do |t|
      t.string :leaderboard_id, null: false, index: {unique: true}
      t.string :name, null: false
      t.timestamps
    end

    create_table :leaderboard_entries, id: false, primary_key: %i[leaderboard_id profile_id] do |t|
      t.string :leaderboard_id, null: false
      t.string :profile_id, null: false
      t.integer :rank, null: false
      t.integer :score, null: false
      t.timestamps
    end

    add_index :leaderboard_entries, %i[leaderboard_id profile_id], unique: true
    add_foreign_key :leaderboard_entries, :leaderboards, column: :leaderboard_id, primary_key: :leaderboard_id
  end
end
