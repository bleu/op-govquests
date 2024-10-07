# spec/support/in_memory_test_case.rb
module InMemoryTestCase
  extend ActiveSupport::Concern

  included do
    before(:each) do
      @previous_event_store = Rails.configuration.event_store
      @previous_command_bus = Rails.configuration.command_bus
      Rails.configuration.event_store = Infra::EventStore.in_memory
      Rails.configuration.command_bus = Arkency::CommandBus.new

      ::ReadModelsConfiguration.new.call(
        Rails.configuration.event_store, Rails.configuration.command_bus
      )
    end

    after(:each) do
      Rails.configuration.event_store = @previous_event_store
      Rails.configuration.command_bus = @previous_command_bus
    end
  end
end
