require "infra"
require_relative "authentication/commands"
require_relative "authentication/events"
require_relative "authentication/on_user_commands"
require_relative "authentication/user"

AUTHENTICATION_NAMESPACE_UUID = "c879634b-ba00-48c5-8ac1-820e3d4cd90c".freeze

module Authentication
  class << self
    def generate_user_id(address, chain_id)
      name = "Address$#{address}-ChainId$#{chain_id}"
      namespace_uuid = AUTHENTICATION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end
  end

  class Configuration
    def call(event_store, command_bus)
      command_handler = OnUserCommands.new(event_store)
      command_bus.register(RegisterUser, command_handler)
      command_bus.register(LogIn, command_handler)
    end
  end
end
