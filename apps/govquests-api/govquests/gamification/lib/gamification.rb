require "infra"
require_relative "gamification/commands"
require_relative "gamification/events"
require_relative "gamification/game_profile"
require_relative "gamification/leaderboard"
require_relative "gamification/badge"

ACTION_BADGE_NAMESPACE_UUID = "5FA78373-03E0-4D0B-91D1-3F2C6CA3F088"

module Gamification
  class << self
    def generate_badge_id(entity_name, entity_id)
      name = "#{entity_name}$#{entity_id}"
      namespace_uuid = ACTION_BADGE_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end

    attr_accessor :event_store, :command_bus
  end

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
        user_address: cmd.user_address
      )
    end

    handle "Gamification::CompleteTokenClaim", aggregate: GameProfile do |profile, cmd|
      profile.complete_token_claim(
        token_address: cmd.token_address,
        claim_metadata: cmd.claim_metadata
      )
    end

    handle "Gamification::CreateBadge", aggregate: Badge do |badge, cmd|
      badge.create(cmd.display_data, cmd.badgeable_id, cmd.badgeable_type)
    end
  end
end
