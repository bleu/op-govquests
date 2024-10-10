require "spec_helper"

RSpec.describe Processes::UpdateQuestProgressOnActionExecutionCompleted do
  let(:event_store) { Infra::EventStore.in_memory }
  let(:command_bus) { FakeCommandBus.new }
  let(:process) { described_class.new(event_store, command_bus) }
  let(:quest_id) { SecureRandom.uuid }
  let(:action_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:execution_id) { SecureRandom.uuid }

  before do
    process.subscribe
  end

  describe "#call" do
    context "when action execution completed event is published" do
      it "dispatches UpdateUserQuestProgress command" do
        action_started_event = action_execution_started_event(execution_id, quest_id, action_id, user_id)
        event_store.publish(action_started_event, stream_name: "ActionExecution$#{execution_id}")

        completion_data = {data: "success"}
        action_completed_event = ActionTracking::ActionExecutionCompleted.new(data: {
          execution_id: execution_id,
          quest_id: quest_id,
          action_id: action_id,
          user_id: user_id,
          completion_data: completion_data
        })

        event_store.publish(action_completed_event)

        expected_command = Questing::UpdateUserQuestProgress.new(
          user_quest_id: Questing.generate_user_quest_id(quest_id, user_id),
          action_id: action_id,
          data: completion_data
        )

        expect(command_bus.received).to eq(expected_command)
      end
    end

    context "when action execution completed event is published without starting" do
      it "does not dispatch UpdateUserQuestProgress command" do
        action_completed_event = ActionTracking::ActionExecutionCompleted.new(data: {
          execution_id: execution_id,
          quest_id: quest_id,
          action_id: action_id,
          user_id: user_id,
          completion_data: {}
        })

        event_store.publish(action_completed_event)

        expect(command_bus.received).to be_nil
      end
    end
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

  def action_execution_started_event(execution_id, quest_id, action_id, user_id)
    ActionTracking::ActionExecutionStarted.new(data: {
      execution_id: execution_id,
      quest_id: quest_id,
      action_id: action_id,
      user_id: user_id,
      action_type: "read_document",
      started_at: Time.now,
      start_data: {},
      nonce: SecureRandom.hex(16)
    })
  end
end
