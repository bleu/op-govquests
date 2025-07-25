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

GAMIFICATION_NAMESPACE_UUID = "101cb511-2dbd-4920-938a-13a56d07a0b8"

module Gamification
  class << self
    def generate_badge_id(badgeable_type, badgeable_id)
      name = "#{badgeable_type}$#{badgeable_id}"
      namespace_uuid = GAMIFICATION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end

    def generate_special_badge_id(badge_data)
      name = "#{badge_data[:display_data][:title]}-#{badge_data[:badge_type]}"
      namespace_uuid = GAMIFICATION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end

    def generate_tier_id(tier_data)
      name = "tier$#{tier_data[:display_data][:title]}"
      namespace_uuid = GAMIFICATION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end

    attr_accessor :event_store, :command_bus
  end

  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)

      Gamification.command_bus = command_bus
      Gamification.event_store = event_store
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

    handle "Gamification::CreateBadge", aggregate: Badge do |badge, cmd|
      badge.create(cmd.display_data, cmd.badgeable_id, cmd.badgeable_type)
    end

    handle "Gamification::UpdateBadge", aggregate: Badge do |badge, cmd|
      badge.update(cmd.display_data)
    end

    handle "Gamification::EarnBadge", aggregate: UserBadge do |user_badge, cmd|
      user_badge.earn_badge(cmd.user_id, cmd.badge_id, cmd.badge_type, cmd.earned_at)
    end

    handle "Gamification::CreateSpecialBadge", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.create(cmd.display_data, cmd.badge_type, cmd.badge_data)
    end

    handle "Gamification::UpdateSpecialBadge", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.update(cmd.display_data, cmd.badge_data)
    end

    handle "Gamification::AssociateRewardPool", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.associate_reward_pool(cmd.pool_id, cmd.reward_definition)
    end

    handle "Gamification::UnlockSpecialBadge", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.verify_completion?(user_id: cmd.user_id)
    end
    
    handle "Gamification::CollectSpecialBadge", aggregate: SpecialBadge do |special_badge, cmd|
      special_badge.collect_badge(cmd.user_id)
    end

    handle "Gamification::CreateTier", aggregate: Tier do |tier, cmd|
      tier.create(cmd.display_data, cmd.min_delegation, cmd.max_delegation, cmd.multiplier, cmd.image_url)
    end

    handle "Gamification::UpdateTier", aggregate: Tier do |tier, cmd|
      tier.update(cmd.display_data, cmd.min_delegation, cmd.max_delegation, cmd.multiplier, cmd.image_url)
    end

    handle "Gamification::CreateGameProfile", aggregate: GameProfile do |profile, cmd|
      profile.create
    end

    handle "Gamification::UpdateGameProfileRank", aggregate: GameProfile do |profile, cmd|
      profile.update_rank(cmd.rank)
    end
  end
end
