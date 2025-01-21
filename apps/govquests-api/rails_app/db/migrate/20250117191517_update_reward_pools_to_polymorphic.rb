class UpdateRewardPoolsToPolymorphic < ActiveRecord::Migration[8.1]
  def change
    rename_column :reward_pools, :quest_id, :rewardable_id
    change_column :reward_pools, :rewardable_id, :string  # Changed from UUID to string
    add_column :reward_pools, :rewardable_type, :string

    add_index :reward_pools, [:rewardable_type, :rewardable_id]
  end
end
