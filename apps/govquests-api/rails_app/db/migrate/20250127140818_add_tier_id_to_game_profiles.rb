class AddTierIdToGameProfiles < ActiveRecord::Migration[8.1]
  def change
    remove_column :user_game_profiles, :tier, :string
    add_column :user_game_profiles, :tier_id, :string
    add_index :user_game_profiles, :tier_id
    add_foreign_key :user_game_profiles, :tiers, column: :tier_id, primary_key: :tier_id
  end
end
