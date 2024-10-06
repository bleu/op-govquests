require "infra"
require_relative "gamification/commands"
require_relative "gamification/events"
require_relative "gamification/on_game_profile_commands"
require_relative "gamification/game_profile"
require_relative "gamification/leaderboard"

module Gamification
  class Configuration
    def call(event_store, command_bus)
      command_handler = OnGameProfileCommands.new(event_store)
      command_bus.register(UpdateScore, command_handler)
      command_bus.register(AchieveTier, command_handler)
      command_bus.register(CompleteTrack, command_handler)
      command_bus.register(MaintainStreak, command_handler)
      command_bus.register(EarnBadge, command_handler)
      command_bus.register(UpdateLeaderboard, command_handler)
    end
  end
end
