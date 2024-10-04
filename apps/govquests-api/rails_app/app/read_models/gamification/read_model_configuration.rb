module Gamification
  class GameProfileReadModel < ApplicationRecord
    self.table_name = "user_game_profiles"

    validates :profile_id, presence: true, uniqueness: true
  end

  # app/models/gamification/leaderboard_read_model.rb

  class LeaderboardReadModel < ApplicationRecord
    self.table_name = "leaderboards"
    self.primary_key = "leaderboard_id"

    has_many :leaderboard_entries,
      foreign_key: "leaderboard_id",
      primary_key: "leaderboard_id",
      class_name: "Gamification::LeaderboardEntryReadModel",
      inverse_of: :leaderboard
  end

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

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnTierAchieved, to: [Gamification::TierAchieved])
      event_store.subscribe(OnTrackCompleted, to: [Gamification::TrackCompleted])
      event_store.subscribe(OnStreakMaintained, to: [Gamification::StreakMaintained])
      event_store.subscribe(OnBadgeEarned, to: [Gamification::BadgeEarned])
      event_store.subscribe(OnLeaderboardUpdated, to: [Gamification::LeaderboardUpdated])
    end
  end
end
