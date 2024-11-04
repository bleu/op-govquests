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

  class CommandHandler
    class << self
      def handle(command_name, aggregate: GameProfile, &block)
        handlers[command_name] = {
          aggregate: aggregate,
          handler: block
        }
      end

      def register_commands(event_store, command_bus)
        handler = new(Infra::AggregateRootRepository.new(event_store))
        handlers.each_key do |command_name|
          command_class = Object.const_get("Gamification::#{command_name}")
          command_bus.register(command_class, handler)
        end
      end

      private

      def handlers
        @handlers ||= {}
      end
    end

    def initialize(repository)
      @repository = repository
    end

    def call(command)
      command_config = self.class.send(:handlers)[extract_command_name(command.class.name)]

      @repository.with_aggregate(command_config[:aggregate], command.aggregate_id) do |aggregate|
        command_config[:handler].call(aggregate, command)
      end
    end

    private

    def extract_command_name(command_class_name)
      command_class_name.split("::").last.to_sym
    end

    # Leaderboard commands
    handle :UpdateLeaderboard, aggregate: Leaderboard do |leaderboard, cmd|
      leaderboard.update_score(cmd.profile_id, cmd.score)
    end

    # Game Profile commands - metrics
    handle :UpdateScore do |profile, cmd|
      profile.update_score(cmd.points)
    end

    handle :AchieveTier do |profile, cmd|
      profile.achieve_tier(cmd.tier)
    end

    handle :CompleteTrack do |profile, cmd|
      profile.complete_track(cmd.track)
    end

    handle :MaintainStreak do |profile, cmd|
      profile.maintain_streak(cmd.streak)
    end

    handle :EarnBadge do |profile, cmd|
      profile.earn_badge(cmd.badge)
    end

    # Game Profile commands - tokens
    handle :AddTokenReward do |profile, cmd|
      profile.add_token_reward(
        token_address: cmd.token_address,
        amount: cmd.amount,
        pool_id: cmd.pool_id
      )
    end

    handle :StartTokenClaim do |profile, cmd|
      profile.start_token_claim(
        token_address: cmd.token_address,
        user_address: cmd.claim_metadata["user_address"]
      )
    end

    handle :CompleteTokenClaim do |profile, cmd|
      profile.complete_token_claim(
        token_address: cmd.token_address,
        claim_metadata: cmd.claim_metadata
      )
    end
  end
end
