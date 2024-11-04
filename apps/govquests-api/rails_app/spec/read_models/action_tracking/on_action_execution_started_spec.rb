require "rails_helper"

RSpec.describe ActionTracking::OnActionExecutionStarted do
  let(:handler) { described_class.new }
  let(:action_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:quest_id) { SecureRandom.uuid }
  let(:timestamp) { Time.current }

  describe "#call" do
    before do
      create_user(
        email: "",
        address: "0x0987654321fedcba",
        chain_id: 2,
        user_id: user_id
      )
      create_quest_with_actions(
        title: "Test Quest",
        quest_id: quest_id,
        actions: [
          {
            action_id: action_id,
            action_type: "read_document",
            action_data: {"url" => "https://example.com/doc1"},
            display_data: {"title" => "Read Document 1"}
          }
        ]
      )
    end
    it "creates a new action execution when handling ActionExecutionStarted event" do
      event = ActionTracking::ActionExecutionStarted.new(data: {
        execution_id: SecureRandom.uuid,
        action_id: action_id,
        user_id: user_id,
        quest_id: quest_id,
        action_type: "read_document",
        started_at: timestamp,
        start_data: {},
        nonce: SecureRandom.hex(16)
      })

      expect {
        handler.call(event)
      }.to change(ActionTracking::ActionExecutionReadModel, :count).by(1)

      action_execution = ActionTracking::ActionExecutionReadModel.last
      expect(action_execution.action_id).to eq(action_id)
      expect(action_execution.user_id).to eq(user_id)
      expect(action_execution.started_at.to_i).to eq(timestamp.to_i)
      expect(action_execution.status).to eq("started")
    end
  end
end
