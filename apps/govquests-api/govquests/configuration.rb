require_relative "authentication/lib/authentication"
require_relative "questing/lib/questing"
require_relative "rewarding/lib/rewarding"
require_relative "notifications/lib/notifications"
require_relative "action_tracking/lib/action_tracking"
require_relative "gamification/lib/gamification"

module GovQuests
  class Configuration
    def initialize
    end

    def call(event_store, command_bus)
      configure_bounded_contexts(event_store, command_bus)
    end

    def configure_bounded_contexts(event_store, command_bus)
      [
        Authentication::Configuration.new,
        Questing::Configuration.new,
        Rewarding::Configuration.new,
        Notifications::Configuration.new,
        ActionTracking::Configuration.new,
        Gamification::Configuration.new
      ].each { |context| context.call(event_store, command_bus) }
    end
  end
end
