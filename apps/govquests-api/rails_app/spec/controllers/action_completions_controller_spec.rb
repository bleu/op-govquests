# spec/controllers/action_completions_controller_spec.rb
require "rails_helper"

RSpec.describe ActionCompletionsController, type: :controller do
  let(:user) { create(:user) }
  let(:action) { create(:action_read_model) }

  describe "POST #start" do
    it "starts action completion" do
      post :start, params: {action_id: action.action_id, user_id: user.user_id, start_data: {some: "data"}}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["token"]).not_to be_nil
    end
  end

  describe "POST #complete" do
    it "completes action with valid token" do
      execution = create(:action_execution_read_model)
      token = generate_valid_token(execution.execution_id)
      post :complete, params: {action_id: execution.action_id, execution_id: execution.execution_id, token: token, user_id: execution.user_id, completion_data: {foo: "bar"}}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["message"]).to eq("Action completed successfully")
    end

    it "does not complete action with invalid token" do
      post :complete, params: {action_id: action.action_id, token: "invalid_token", completion_data: {foo: "bar"}}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  def generate_valid_token(action_id)
    payload = {
      action_id: action_id,
      user_id: user.user_id,
      exp: 30.minutes.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
