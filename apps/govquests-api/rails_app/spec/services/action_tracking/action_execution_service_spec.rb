require "rails_helper"

RSpec.describe ActionTracking::ActionExecutionService do
  let(:quest_id) { SecureRandom.uuid }
  let(:action_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:execution_id) { ActionTracking.generate_execution_id(quest_id, action_id, user_id) }

  before do
    # Setup user, action, and quest
    create_user(email: "test@example.com", address: "0xABCDEF", chain_id: 1, user_id: user_id)
    create_quest_with_actions(title: "Test Quest", quest_id: quest_id, actions: [{action_id: action_id, action_type: "read_document", action_data: {"url" => "https://example.com/doc1"}}])

    # Start action execution
    start_action_execution(user_id: user_id, action_id: action_id, quest_id: quest_id)
  end

  describe ".complete" do
    context "with valid execution_id and nonce" do
      let(:nonce) { ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id).nonce }

      it "completes the action execution successfully" do
        result = ActionTracking::ActionExecutionService.complete(
          execution_id: execution_id,
          nonce: nonce,
          user_id: user_id,
          completion_data: {"completed_at" => Time.current}
        )

        expect(result).to be_a(ActionTracking::ActionExecutionReadModel)
        expect(result.status).to eq("completed")
        expect(result.completion_data).to include({"completed_at" => result.completion_data["completed_at"]})
      end
    end

    context "with invalid nonce" do
      it "returns an error" do
        result = ActionTracking::ActionExecutionService.complete(
          execution_id: execution_id,
          nonce: "invalidnonce",
          user_id: user_id,
          completion_data: {}
        )

        expect(result).to eq({error: "Invalid nonce"})
      end
    end

    context "when execution is not started" do
      it "returns an error" do
        invalid_execution_id = SecureRandom.uuid
        result = ActionTracking::ActionExecutionService.complete(
          execution_id: invalid_execution_id,
          nonce: "nonce",
          user_id: user_id,
          completion_data: {}
        )

        expect(result).to eq({error: "Execution not started"})
      end
    end

    context "when execution is already completed" do
      let(:nonce) { ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id).nonce }
      before do
        complete_action_execution(execution_id: execution_id, nonce: nonce, completion_data: {})
      end

      it "returns an error" do
        result = ActionTracking::ActionExecutionService.complete(
          execution_id: execution_id,
          nonce: nonce,
          user_id: user_id,
          completion_data: {}
        )

        expect(result).to eq({error: "Execution already completed"})
      end
    end
  end
end
