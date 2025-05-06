module Gamification
  class GameProfileReadModel < ApplicationRecord
    self.table_name = "user_game_profiles"

    attribute :unclaimed_tokens, :jsonb, default: {}
    attribute :active_claim, :jsonb

    belongs_to :tier,
      class_name: "Gamification::TierReadModel",
      foreign_key: "tier_id",
      primary_key: "tier_id",
      optional: true

    belongs_to :user,
      class_name: "Authentication::UserReadModel",
      foreign_key: "profile_id",
      primary_key: "user_id"

    delegate :leaderboard, to: :tier

    def unclaimed_balance_for(token_address)
      unclaimed_tokens[token_address].to_i
    end

    def can_claim?(token_address)
      balance = unclaimed_balance_for(token_address)
      balance >= Rails.configuration.min_claimable_amount
    end

    def active_claim?
      active_claim.present?
    end
  end
end

# == Schema Information
#
# Table name: user_game_profiles
#
#  id               :bigint           not null, primary key
#  active_claim     :jsonb
#  badges           :jsonb
#  delegatee        :string
#  rank             :integer
#  score            :integer          default(0)
#  streak           :integer          default(0)
#  track            :integer          default(0)
#  unclaimed_tokens :jsonb
#  voting_power     :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  profile_id       :string           not null
#  tier_id          :string
#
# Indexes
#
#  index_user_game_profiles_on_profile_id        (profile_id) UNIQUE
#  index_user_game_profiles_on_tier_id           (tier_id)
#  index_user_game_profiles_on_tier_id_and_rank  (tier_id,rank)
#
# Foreign Keys
#
#  fk_rails_...  (tier_id => tiers.tier_id)
#
