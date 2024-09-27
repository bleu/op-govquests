require "infra"
require_relative "authentication/commands/register_account"
require_relative "authentication/events/account_registered"
require_relative "authentication/account_service"
require_relative "authentication/account"

module Authentication
  class Configuration
    def call(event_store, command_bus)
      command_bus.register(RegisterAccount, RegisterAccountHandler.new(event_store))
    end
  end
end
