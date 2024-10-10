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
