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
          # Game metrics commands
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

          when AddTokenReward
            profile.add_token_reward(
              token_address: command.token_address,
              amount: command.amount,
              pool_id: command.pool_id
            )
          when StartTokenClaim
            profile.start_token_claim(
              token_address: command.token_address,
              claim_metadata: command.claim_metadata
            )
          when CompleteTokenClaim
            profile.complete_token_claim(
              token_address: command.token_address,
              claim_metadata: command.claim_metadata
            )
          end
        end
      end
    end
  end
end
