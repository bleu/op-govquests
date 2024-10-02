require "infra"
require_relative "questing/commands"
require_relative "questing/events"
require_relative "questing/on_quest_commands"
require_relative "questing/quest"

# app/read_models/quests/configuration.rb
module Questing
  class Configuration
    def call(event_store, command_bus)
      event_store.subscribe(CreateQuest, to: [Questing::QuestCreated])
      event_store.subscribe(UpdateQuestStatus, to: [Questing::QuestProgressUpdated])
      # Add additional subscriptions as needed
    end
  end
end
