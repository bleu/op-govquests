require "infra"
require_relative "questing/commands"
require_relative "questing/events"
require_relative "questing/on_quest_commands"
require_relative "questing/quest"

module Questing
  class Configuration
    def call(event_store, command_bus)
      command_handler = OnQuestCommands.new(event_store)
      command_bus.register(CreateQuest, command_handler)
      command_bus.register(AssociateActionWithQuest, command_handler)
    end
  end
end
