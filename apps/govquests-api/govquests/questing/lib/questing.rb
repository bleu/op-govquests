require "infra"
require_relative "questing/commands"
require_relative "questing/events"
require_relative "questing/on_quest_commands"
require_relative "questing/quest"
require_relative "questing/user_quest"

QUESTING_NAMESPACE_UUID = "14f9d670-d4f7-4fea-bc48-1438f0f9f11c".freeze

module Questing
  class << self
    def generate_user_quest_id(quest_id, user_id)
      name = "Quest$#{quest_id}-User$#{user_id}"
      namespace_uuid = QUESTING_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end
  end

  class Configuration
    def call(event_store, command_bus)
      command_handler = OnQuestCommands.new(event_store)
      command_bus.register(CreateQuest, command_handler)
      command_bus.register(AssociateActionWithQuest, command_handler)
      command_bus.register(AssociateRewardPool, command_handler)
      command_bus.register(StartUserQuest, command_handler)
      command_bus.register(CompleteUserQuest, command_handler)
      command_bus.register(UpdateUserQuestProgress, command_handler)
    end
  end
end
