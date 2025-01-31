class AddVotingPowerToGameProfile < ActiveRecord::Migration[8.1]
  def change
    add_column :user_game_profiles, :voting_power, :integer, default: 0
  end
end
