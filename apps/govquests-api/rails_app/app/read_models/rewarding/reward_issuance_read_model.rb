module Rewarding
  class RewardIssuanceReadModel < ApplicationRecord
    self.table_name = "reward_issuances"

    belongs_to :pool, class_name: "Rewarding::RewardPoolReadModel", foreign_key: "pool_id", primary_key: "pool_id"
    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: "user_id", primary_key: "user_id"

    validates :issued_at, presence: true
  end
end
