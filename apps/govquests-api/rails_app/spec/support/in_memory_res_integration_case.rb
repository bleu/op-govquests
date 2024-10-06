module InMemoryRESIntegrationCase
  extend ActiveSupport::Concern

  included do
    before(:each) do
      @previous_event_store = Rails.configuration.event_store
      @previous_command_bus = Rails.configuration.command_bus
      Rails.configuration.event_store = Infra::EventStore.in_memory_rails
      Rails.configuration.command_bus = Arkency::CommandBus.new

      ::ReadModelsConfiguration.new.call(Rails.configuration.event_store, Rails.configuration.command_bus)
    end

    after(:each) do
      Rails.configuration.event_store = @previous_event_store
      Rails.configuration.command_bus = @previous_command_bus
    end
  end
end
