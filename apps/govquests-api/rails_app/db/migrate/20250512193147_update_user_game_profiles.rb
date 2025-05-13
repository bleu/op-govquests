class UpdateUserGameProfiles < ActiveRecord::Migration[8.1]
  def change
    remove_column :user_game_profiles, :unclaimed_tokens
    remove_column :user_game_profiles, :active_claim
    remove_column :user_game_profiles, :track
    remove_column :user_game_profiles, :streak
    remove_column :user_game_profiles, :badges
  end
end
