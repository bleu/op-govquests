module Gamification
  class TierReadModel < ApplicationRecord
    self.table_name = "tiers"

    validates :tier_id, presence: true, uniqueness: true
    validates :display_data, presence: true

    has_many :game_profiles,
      class_name: "Gamification::GameProfileReadModel",
      foreign_key: "tier_id",
      primary_key: "tier_id",
      inverse_of: :tier

    has_one :leaderboard,
      class_name: "Gamification::LeaderboardReadModel",
      foreign_key: "tier_id",
      primary_key: "tier_id",
      inverse_of: :tier

    scope :ordered_by_progression, -> { order(:min_delegation, :max_delegation) }
  end
end

# == Schema Information
#
# Table name: tiers
#
#  id             :bigint           not null, primary key
#  display_data   :jsonb            not null
#  image_url      :string
#  max_delegation :bigint
#  min_delegation :bigint           not null
#  multiplier     :float            default(1.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tier_id        :string           not null
#
# Indexes
#
#  index_tiers_on_tier_id  (tier_id) UNIQUE
#
