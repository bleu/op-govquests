class RemoveRemainingInventoryFromRewardPools < ActiveRecord::Migration[8.1]
  def change
    remove_column :reward_pools, :remaining_inventory, :integer
  end
end
