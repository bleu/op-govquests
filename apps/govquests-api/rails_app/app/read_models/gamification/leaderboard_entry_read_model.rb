module Gamification
  class LeaderboardEntryReadModel < ApplicationRecord
    self.table_name = "leaderboard_entries"
    query_constraints :leaderboard_id, :profile_id

    belongs_to :leaderboard,
      foreign_key: "leaderboard_id",
      primary_key: "leaderboard_id",
      class_name: "Gamification::LeaderboardReadModel",
      inverse_of: :leaderboard_entries

    validates :rank, presence: true
    validates :score, presence: true
  end
end
