require_relative "authentication/lib/authentication"


module Govquests
  class Configuration
    def initialize;end

    def call(event_store, command_bus)
      configure_bounded_contexts(event_store, command_bus)
    end

    def configure_bounded_contexts(event_store, command_bus)
      [
        Authentication::Configuration.new,
      ].each { |c| c.call(event_store, command_bus) }
    end

  end
end
