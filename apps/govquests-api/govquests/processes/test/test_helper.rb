require "minitest/autorun"
require "mutant/minitest/coverage"

require_relative "../lib/processes"

module Processes
  class Test < Infra::InMemoryTest
    include Infra::TestPlumbing.with(
      event_store: -> { Infra::EventStore.in_memory },
      command_bus: -> { FakeCommandBus.new }
    )

    def before_setup
      super
      Configuration.new.call(event_store, command_bus)
    end

    def assert_command(command)
      assert_equal(command, @command_bus.received)
    end

    def assert_all_commands(*commands)
      assert_equal(commands, @command_bus.all_received)
    end

    def assert_no_command
      assert_nil(@command_bus.received)
    end

    private

    class FakeCommandBus
      attr_reader :received, :all_received

      def initialize
        @all_received = []
      end

      def call(command)
        @received = command
        @all_received << command
      end

      def clear_all_received
        @all_received, @received = [], nil
      end
    end

    def given(events, store: event_store)
      events.each { |ev| store.append(ev) }
      events
    end
  end
end
