module Gamification
  class LeaderboardReadModel < ApplicationRecord
    self.table_name = "leaderboards"
    self.primary_key = "leaderboard_id"

    has_many :leaderboard_entries,
      foreign_key: "leaderboard_id",
      primary_key: "leaderboard_id",
      class_name: "Gamification::GameProfileReadModel",
      inverse_of: :leaderboard

    belongs_to :tier,
      foreign_key: "tier_id",
      primary_key: "tier_id",
      class_name: "Gamification::TierReadModel",
      inverse_of: :leaderboard

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
