module Gamification
  class LeaderboardReadModel < ApplicationRecord
    self.table_name = "leaderboards"
    self.primary_key = "leaderboard_id"

    has_many :leaderboard_entries,
      foreign_key: "leaderboard_id",
      primary_key: "leaderboard_id",
      class_name: "Gamification::LeaderboardEntryReadModel",
      inverse_of: :leaderboard
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
#
# Indexes
#
#  index_leaderboards_on_leaderboard_id  (leaderboard_id) UNIQUE
#
