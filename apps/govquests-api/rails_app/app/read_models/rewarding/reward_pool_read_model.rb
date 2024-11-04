module Rewarding
  class RewardPoolReadModel < ApplicationRecord
    self.table_name = "reward_pools"

    has_many :issued_rewards,
      class_name: "Rewarding::RewardIssuanceReadModel",
      foreign_key: "pool_id",
      primary_key: "pool_id"

    has_many :rewarded_users,
      through: :issued_rewards,
      source: :user
  end
end

# == Schema Information
#
# Table name: reward_pools
#
#  id                  :bigint           not null, primary key
#  remaining_inventory :integer
#  reward_definition   :jsonb            not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  pool_id             :uuid             not null
#  quest_id            :uuid             not null
#
# Indexes
#
#  index_reward_pools_on_pool_id   (pool_id) UNIQUE
#  index_reward_pools_on_quest_id  (quest_id)
#
