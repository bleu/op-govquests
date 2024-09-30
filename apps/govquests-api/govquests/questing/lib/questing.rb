require "infra"
require_relative "questing/commands/register_quest"
require_relative "questing/events/quest_registered"
require_relative "questing/quest_service"
require_relative "questing/quest"

module Questing
  class Configuration
    def call(event_store, command_bus)
      command_bus.register(RegisterQuest, OnQuestCreated.new(event_store))
    end
  end
end
