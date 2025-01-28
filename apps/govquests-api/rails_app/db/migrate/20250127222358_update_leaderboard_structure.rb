class UpdateLeaderboardStructure < ActiveRecord::Migration[8.1]
  def change
    remove_column :user_game_profiles, :tier, :string
    add_column :user_game_profiles, :tier_id, :string
    add_index :user_game_profiles, :tier_id
    add_foreign_key :user_game_profiles, :tiers, column: :tier_id, primary_key: :tier_id

    add_column :user_game_profiles, :rank, :integer
    add_index :user_game_profiles, [:tier_id, :rank]

    add_column :user_game_profiles, :leaderboard_id, :string
    add_index :user_game_profiles, :leaderboard_id
    add_foreign_key :user_game_profiles, :leaderboards, column: :leaderboard_id, primary_key: :leaderboard_id

    add_column :leaderboards, :tier_id, :string
    add_foreign_key :leaderboards, :tiers, column: :tier_id, primary_key: :tier_id
    add_index :leaderboards, :tier_id, unique: true

    drop_table :leaderboard_entries
  end
end
