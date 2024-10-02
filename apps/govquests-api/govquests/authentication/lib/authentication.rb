require "infra"
require_relative "authentication/commands"
require_relative "authentication/events"
require_relative "authentication/on_user_commands"
require_relative "authentication/user"

module Authentication
  class Configuration
    def call(event_store, command_bus)
      command_handler = OnUserCommands.new(event_store)
      command_bus.register(RegisterUser, command_handler)
      command_bus.register(UpdateQuestProgress, command_handler)
      command_bus.register(ClaimReward, command_handler)
      command_bus.register(LogUserActivity, command_handler)
    end
  end
end
