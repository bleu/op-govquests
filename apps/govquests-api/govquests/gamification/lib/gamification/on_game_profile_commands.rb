module Gamification
  class OnGameProfileCommands
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      case command
      when UpdateLeaderboard
        @repository.with_aggregate(Leaderboard, command.aggregate_id) do |leaderboard|
          leaderboard.update_score(command.profile_id, command.score)
        end
      else
        @repository.with_aggregate(GameProfile, command.aggregate_id) do |profile|
          case command
          when UpdateScore
            profile.update_score(command.points)
          when AchieveTier
            profile.achieve_tier(command.tier)
          when CompleteTrack
            profile.complete_track(command.track)
          when MaintainStreak
            profile.maintain_streak(command.streak)
          when EarnBadge
            profile.earn_badge(command.badge)
          end
        end
      end
    end
  end
end
