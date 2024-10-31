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
