require "rails_helper"
RSpec.describe ActionExecutionsController, type: :controller do
  include InMemoryRESIntegrationCase

  let(:user) { create_user }
  let(:action) { create_action }

  describe "POST #start" do
    it "starts action execution" do
      post :start, params: {action_id: action.action_id, user_id: user.user_id, data: {some: "data"}}

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["nonce"]).to be_present
      expect(json_response["execution_id"]).to be_present
    end

    it "returns not found for non-existent action" do
      post :start, params: {action_id: "non_existent_id", user_id: user.user_id, data: {some: "data"}}

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #complete" do
    let(:execution) { start_action_execution(action, user) }

    it "completes action execution with valid nonce" do
      post :complete, params: {
        execution_id: execution.execution_id,
        user_id: user.user_id,
        nonce: execution.nonce,
        completion_data: {foo: "bar"}
      }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["message"]).to eq("Action completed successfully")
    end

    it "does not complete action with invalid nonce" do
      post :complete, params: {
        execution_id: execution.execution_id,
        nonce: "invalid_nonce",
        user_id: user.user_id,
        completion_data: {foo: "bar"}
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  def create_user
    user_id = SecureRandom.uuid
    command = Authentication::RegisterUser.new(
      user_id: user_id,
      email: "test@example.com",
      user_type: "non_delegate",
      wallet_address: "0x" + SecureRandom.hex(20),
      chain_id: 10
    )
    run_command(command)
    Authentication::UserReadModel.find_by(user_id: user_id)
  end

  def create_action
    action_id = SecureRandom.uuid
    command = ActionTracking::CreateAction.new(
      action_id: action_id,
      action_type: "read_document",
      action_data: {test: "data"},
      display_data: {content: "Test Action"}
    )
    run_command(command)
    ActionTracking::ActionReadModel.find_by(action_id: action_id)
  end

  def start_action_execution(action, user)
    execution_id = SecureRandom.uuid
    command = ActionTracking::StartActionExecution.new(
      execution_id: execution_id,
      action_id: action.action_id,
      user_id: user.user_id,
      start_data: {start: "data"}
    )
    run_command(command)
    ActionTracking::ActionExecutionReadModel.find_by(execution_id: execution_id)
  end

  def run_command(command)
    Rails.configuration.command_bus.call(command)
  end
end
