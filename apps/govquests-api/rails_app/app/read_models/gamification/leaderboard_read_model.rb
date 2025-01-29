module Gamification
  class LeaderboardReadModel < ApplicationRecord
    self.table_name = "leaderboards"
    self.primary_key = "leaderboard_id"

    belongs_to :tier,
      foreign_key: "tier_id",
      primary_key: "tier_id",
      class_name: "Gamification::TierReadModel",
      inverse_of: :leaderboard

    def game_profiles
      tier.game_profiles.order(:rank)
    end

    scope :ordered_profiles, -> { game_profiles.order(:rank) }
  end
end

# == Schema Information
#
# Table name: leaderboards
#
#  name           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  leaderboard_id :string           not null, primary key
#  tier_id        :string
#
# Indexes
#
#  index_leaderboards_on_leaderboard_id  (leaderboard_id) UNIQUE
#  index_leaderboards_on_tier_id         (tier_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tier_id => tiers.tier_id)
#
