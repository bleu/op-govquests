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

    belongs_to :rewardable, polymorphic: true

    scope :token, -> { where("reward_definition->>'type' = 'Token'") }
  end
end

# == Schema Information
#
# Table name: reward_pools
#
#  id                :bigint           not null, primary key
#  reward_definition :jsonb            not null
#  rewardable_type   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  pool_id           :uuid             not null
#  rewardable_id     :string           not null
#
# Indexes
#
#  index_reward_pools_on_pool_id                            (pool_id) UNIQUE
#  index_reward_pools_on_rewardable_id                      (rewardable_id)
#  index_reward_pools_on_rewardable_type_and_rewardable_id  (rewardable_type,rewardable_id)
#
