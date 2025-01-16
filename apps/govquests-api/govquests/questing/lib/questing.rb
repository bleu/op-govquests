require "infra"
require_relative "questing/commands"
require_relative "questing/events"

require_relative "questing/quest"
require_relative "questing/user_quest"
require_relative "questing/track"

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
      CommandHandler.register_commands(event_store, command_bus)
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    handle "Questing::CreateQuest", aggregate: Quest do |quest, cmd|
      quest.create(cmd.display_data, cmd.audience, cmd.badge_display_data)
    end

    handle "Questing::AssociateActionWithQuest", aggregate: Quest do |quest, cmd|
      quest.associate_action(cmd.action_id, cmd.position)
    end

    handle "Questing::AssociateRewardPool", aggregate: Quest do |quest, cmd|
      quest.associate_reward_pool(cmd.pool_id, cmd.reward_definition)
    end

    handle "Questing::StartUserQuest", aggregate: UserQuest do |user_quest, cmd, repository|
      repository.with_aggregate(Quest, cmd.quest_id) do |quest|
        actions = quest.actions.map { |action| action[:id] }

        user_quest.start(cmd.quest_id, cmd.user_id, actions)
      end
    end

    handle "Questing::CompleteUserQuest", aggregate: UserQuest do |user_quest, cmd|
      user_quest.complete
    end

    handle "Questing::UpdateUserQuestProgress", aggregate: UserQuest do |user_quest, cmd|
      user_quest.add_progress(cmd.action_id, cmd.data)
    end

    handle "Questing::CreateTrack", aggregate: Track do |track, cmd|
      track.create(
        display_data: cmd.display_data,
        quest_ids: cmd.quest_ids,
        badge_display_data: cmd.badge_display_data
      )
    end

    handle "Questing::CompleteTrack", aggregate: Track do |track, cmd|
      track.complete(user_id: cmd.user_id)
    end
  end
end
