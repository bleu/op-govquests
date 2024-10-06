require "rails_event_store"
require "aggregate_root"
require "arkency/command_bus"

require_relative "../../lib/read_models_configuration"

Rails.configuration.to_prepare do
  Rails.configuration.event_store = Infra::EventStore.main
  Rails.configuration.command_bus = Arkency::CommandBus.new

  ReadModelsConfiguration.new.call(Rails.configuration.event_store, Rails.configuration.command_bus)
end
