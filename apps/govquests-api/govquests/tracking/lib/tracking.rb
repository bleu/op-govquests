require "infra"

require_relative "tracking/commands"
require_relative "tracking/events"
require_relative "tracking/track"

TRACKING_NAMESPACE_UUID = "24f9d670-d4f7-4fea-bc48-1438f0f9f11d".freeze

module Tracking
  class << self
    def generate_track_id(audience)
      name = "Track$#{audience}"
      namespace_uuid = TRACKING_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end
  end

  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    handle "Tracking::CreateTrack", aggregate: Track do |track, cmd|
      track.create(
        display_data: cmd.display_data,
      )
    end

    handle "Tracking::AssociateQuestWithTrack", aggregate: Track do |track, cmd|
      track.associate_quest(
        quest_id: cmd.quest_id,
        position: cmd.position
      )
    end
  end
end