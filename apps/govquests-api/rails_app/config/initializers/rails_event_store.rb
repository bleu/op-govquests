require "rails_event_store"
require "aggregate_root"
require "arkency/command_bus"

require_relative "../../lib/configuration"


Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  Configuration.new.call(Rails.configuration.event_store, Rails.configuration.command_bus)
end