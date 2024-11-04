require "infra"
require_relative "gamification/commands"
require_relative "gamification/events"
require_relative "gamification/game_profile"
require_relative "gamification/leaderboard"

module Gamification
  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    # Leaderboard commands
    handle "Gamification::UpdateLeaderboard", aggregate: Leaderboard do |leaderboard, cmd|
      leaderboard.update_score(cmd.profile_id, cmd.score)
    end

    # Game Profile commands - metrics
    handle "Gamification::UpdateScore", aggregate: GameProfile do |profile, cmd|
      profile.update_score(cmd.points)
    end

    handle "Gamification::AchieveTier", aggregate: GameProfile do |profile, cmd|
      profile.achieve_tier(cmd.tier)
    end

    handle "Gamification::CompleteTrack", aggregate: GameProfile do |profile, cmd|
      profile.complete_track(cmd.track)
    end

    handle "Gamification::MaintainStreak", aggregate: GameProfile do |profile, cmd|
      profile.maintain_streak(cmd.streak)
    end

    handle "Gamification::EarnBadge", aggregate: GameProfile do |profile, cmd|
      profile.earn_badge(cmd.badge)
    end

    # Game Profile commands - tokens
    handle "Gamification::AddTokenReward", aggregate: GameProfile do |profile, cmd|
      profile.add_token_reward(
        token_address: cmd.token_address,
        amount: cmd.amount,
        pool_id: cmd.pool_id
      )
    end

    handle "Gamification::StartTokenClaim", aggregate: GameProfile do |profile, cmd|
      profile.start_token_claim(
        token_address: cmd.token_address,
        user_address: cmd.claim_metadata["user_address"]
      )
    end

    handle "Gamification::CompleteTokenClaim", aggregate: GameProfile do |profile, cmd|
      profile.complete_token_claim(
        token_address: cmd.token_address,
        claim_metadata: cmd.claim_metadata
      )
    end
  end
end
