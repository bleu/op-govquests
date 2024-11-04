module Gamification
  class GameProfileReadModel < ApplicationRecord
    self.table_name = "user_game_profiles"

    attribute :tier, :string
    attribute :unclaimed_tokens, :jsonb, default: {}
    attribute :active_claim, :jsonb

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
#  id         :bigint           not null, primary key
#  badges     :jsonb
#  score      :integer          default(0)
#  streak     :integer          default(0)
#  tier       :integer          default("0")
#  track      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :string           not null
#
# Indexes
#
#  index_user_game_profiles_on_profile_id  (profile_id) UNIQUE
#
