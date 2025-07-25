module Rewarding
  class RewardIssuanceReadModel < ApplicationRecord
    self.table_name = "reward_issuances"

    belongs_to :pool,
      class_name: "Rewarding::RewardPoolReadModel",
      foreign_key: "pool_id",
      primary_key: "pool_id"

    belongs_to :user,
      class_name: "Authentication::UserReadModel",
      foreign_key: "user_id",
      primary_key: "user_id"

    validates :issued_at, presence: true

    scope :issued, -> { where(claim_started_at: nil) }
    scope :pending_claims, -> {
      where.not(claim_started_at: nil)
        .where(claim_completed_at: nil)
    }
    scope :completed_claims, -> {
      where.not(claim_completed_at: nil)
    }

    def status
      return :claim_completed if claim_completed_at
      return :claim_started if claim_started_at
      :issued
    end
  end
end

# == Schema Information
#
# Table name: reward_issuances
#
#  id             :bigint           not null, primary key
#  claim_metadata :jsonb            not null
#  confirmed_at   :datetime
#  issued_at      :datetime         not null
#  status         :string           default("completed")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pool_id        :uuid             not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_reward_issuances_on_pool_id_and_user_id  (pool_id,user_id) UNIQUE
#  index_reward_issuances_on_user_id              (user_id)
#
