require_relative "../../../govquests/configuration"
module Infra
  module TestPlumbing
    extend RSpec::SharedContext

    shared_context "with test plumbing" do
      # Initialize event_store and command_bus using let
      let(:event_store) { Infra::EventStore.in_memory }
      let(:command_bus) { Arkency::CommandBus.new }

      before do
        # Call the Configuration to set up the environment
        GovQuests::Configuration.new.call(event_store, command_bus)
      end

      # Helper Methods

      # Arrange: Preload commands by acting on each
      def arrange(*commands)
        commands.each { |command| act(command) }
      end

      # Act: Send a command via the command_bus
      def act(command)
        command_bus.call(command)
      end
      alias_method :run_command, :act

      # Assert that a specific command was received
      def assert_command(expected_command)
        expect(command_bus.received).to eq(expected_command)
      end

      # Assert that all expected commands were received
      def assert_all_commands(*expected_commands)
        expect(command_bus.all_received).to match_array(expected_commands)
      end

      # Assert that no command was received
      def assert_no_command
        expect(command_bus.received).to be_nil
      end

      # Assert that specific events were published to a stream
      def assert_events(stream_name, *expected_events)
        scope = event_store.read.stream(stream_name)
        before = scope.last
        yield
        actual_events =
          before.nil? ? scope.to_a : scope.from(before.event_id).to_a
        to_compare = ->(ev) { {type: ev.event_type, data: ev.data} }
        expect(actual_events.map(&to_compare)).to include(*expected_events.map(&to_compare))
      end

      # Assert that specific events are contained within a stream after an action
      def assert_events_contain(stream_name, *expected_events)
        scope = event_store.read.stream(stream_name)
        before = scope.last
        yield
        actual_events =
          before.nil? ? scope.to_a : scope.from(before.event_id).to_a
        to_compare = ->(ev) { {type: ev.event_type, data: ev.data} }
        expected_events.map(&to_compare).each do |expected|
          expect(actual_events.map(&to_compare)).to include(expected)
        end
      end

      # Assert that actual events match expected changes
      def assert_changes(actuals, expected)
        expects = expected.map(&:data)
        expect(actuals.map(&:data)).to eq(expects)
      end

      # FakeCommandBus definition
      class FakeCommandBus
        attr_reader :received, :all_received

        def initialize
          @received = nil
          @all_received = []
        end

        def call(command)
          @received = command
          @all_received << command
        end

        def clear_all_received
          @received = nil
          @all_received.clear
        end
      end
    end
  end
end
