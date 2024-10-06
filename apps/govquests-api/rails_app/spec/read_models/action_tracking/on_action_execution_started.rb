require "rails_helper"

RSpec.describe ActionTracking::OnActionExecutionStarted do
  let(:handler) { described_class.new }
  let(:action_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:timestamp) { Time.current }
  let(:completion_data) { {"result" => "success"} }

  describe "#call" do
    it "creates a new action log when handling ActionExecuted event" do
      event = ActionTracking::ActionExecutionStarted.new(data: {
        action_id: action_id,
        user_id: user_id,
        timestamp: timestamp,
        completion_data: completion_data
      })

      expect {
        handler.call(event)
      }.to change(ActionTracking::ActionLogReadModel, :count).by(1)

      action_log = ActionTracking::ActionLogReadModel.last
      expect(action_log.action_id).to eq(action_id)
      expect(action_log.user_id).to eq(user_id)
      expect(action_log.executed_at.to_i).to eq(timestamp.to_i)
      expect(action_log.status).to eq("Executed")
    end
  end
end
