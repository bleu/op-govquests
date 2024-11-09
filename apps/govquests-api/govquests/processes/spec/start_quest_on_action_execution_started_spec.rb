require "spec_helper"

RSpec.describe Processes::StartQuestOnActionExecutionStarted do
  let(:event_store) { Infra::EventStore.in_memory }
  let(:command_bus) { FakeCommandBus.new }
  let(:process) { described_class.new(event_store, command_bus) }
  let(:quest_id) { SecureRandom.uuid }
  let(:action_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  before do
    process.subscribe
  end

  describe "#call" do
    context "when action execution started event is published" do
      it "dispatches StartUserQuest command" do
        event = action_execution_started_event(quest_id, action_id, user_id)
        event_store.publish(event)

        expected_command = Questing::StartUserQuest.new(
          user_quest_id: Questing.generate_user_quest_id(quest_id, user_id),
          quest_id: quest_id,
          user_id: user_id
        )

        expect(command_bus.received).to eq(expected_command)
      end
    end

    context "when quest is already started" do
      it "does not dispatch StartUserQuest command" do
        user_quest_id = Questing.generate_user_quest_id(quest_id, user_id)
        stream_name = "UserQuest$#{user_quest_id}"

        quest_started_event = Questing::QuestStarted.new(data: {
          user_quest_id: user_quest_id,
          quest_id: quest_id,
          user_id: user_id
        })

        event_store.append(quest_started_event, stream_name: stream_name)

        event = action_execution_started_event(quest_id, action_id, user_id)
        event_store.publish(event)

        expect(command_bus.received).to be_nil
      end
    end

    context "when quest_id is missing in event data" do
      it "does not dispatch StartUserQuest command" do
        event = action_execution_started_event(nil, action_id, user_id)
        event_store.publish(event)

        expect(command_bus.received).to be_nil
      end
    end
  end

  private

  def action_execution_started_event(quest_id, action_id, user_id)
    ActionTracking::ActionExecutionStarted.new(data: {
      execution_id: SecureRandom.uuid,
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
