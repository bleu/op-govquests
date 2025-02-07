require "infra"
require_relative "gamification/commands"
require_relative "gamification/events"
require_relative "gamification/game_profile"
require_relative "gamification/leaderboard"
require_relative "gamification/badge"
require_relative "gamification/user_badge"
require_relative "gamification/special_badge"
require_relative "gamification/tier"

require_relative "gamification/strategies/base"
require_relative "gamification/strategies/special_badge_strategy_factory"

Dir[File.join(__dir__, "gamification/strategies/*.rb")].each do |f|
  next if f.end_with?("base.rb")
  next if f.end_with?("special_badge_strategy_factory.rb")
  require_relative f
end

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

      Gamification.command_bus = command_bus
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    # Leaderboard commands
    handle "Gamification::UpdateLeaderboard", aggregate: Leaderboard do |leaderboard, cmd|
      leaderboard.update_ranking
    end

    # Game Profile commands - metrics
    handle "Gamification::UpdateScore", aggregate: GameProfile do |profile, cmd|
      profile.update_score(cmd.points)
    end

    handle "Gamification::UpdateVotingPower", aggregate: GameProfile do |profile, cmd|
      profile.update_voting_power(cmd.total_voting_power, cmd.voting_power_relative_to_votable_supply)
    end

    handle "Gamification::AchieveTier", aggregate: GameProfile do |profile, cmd|
      profile.achieve_tier(cmd.tier_id)
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

    handle "Gamification::EarnBadge", aggregate: UserBadge do |user_badge, cmd|
      user_badge.earn_badge(cmd.user_id, cmd.badge_id, cmd.badge_type, cmd.earned_at)
    end

    handle "Gamification::CreateSpecialBadge", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.create(cmd.display_data, cmd.badge_type, cmd.badge_data)
    end

    handle "Gamification::AssociateRewardPool", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.associate_reward_pool(cmd.pool_id, cmd.reward_definition)
    end
    
    handle "Gamification::CollectSpecialBadge", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.collect_badge(cmd.user_id)
    end

    handle "Gamification::CreateTier", aggregate: Tier do |tier, cmd|
      tier.create(cmd.display_data, cmd.min_delegation, cmd.max_delegation, cmd.multiplier, cmd.image_url)
    end

    handle "Gamification::CreateGameProfile", aggregate: GameProfile do |profile, cmd|
      profile.create
    end
  end
end
