require "rails_helper"

RSpec.describe ActionTracking::OnActionExecutionStarted do
  let(:handler) { described_class.new }
  let(:action_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:timestamp) { Time.current }

  describe "#call" do
    it "creates a new action execution when handling ActionExecutionStarted event" do
      event = ActionTracking::ActionExecutionStarted.new(data: {
        execution_id: SecureRandom.uuid,
        action_id: action_id,
        user_id: user_id,
        action_type: "read_document",
        started_at: timestamp,
        start_data: {},
        salt: SecureRandom.hex(16)
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
