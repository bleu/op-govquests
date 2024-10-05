# test/controllers/action_completions_controller_test.rb
require "test_helper"

class ActionCompletionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @action = create(:action_read_model)
    sign_in @user
  end

  test "should start action completion" do
    post start_action_completion_path(@action.action_id)
    assert_response :success
    assert_not_nil JSON.parse(response.body)["token"]
  end

  test "should complete action" do
    token = generate_valid_token(@action.action_id)
    post complete_action_completion_path(@action.action_id), params: {token: token, completion_data: {foo: "bar"}}
    assert_response :success
    assert_equal "Action completed successfully", JSON.parse(response.body)["message"]
  end

  test "should not complete action with invalid token" do
    post complete_action_completion_path(@action.action_id), params: {token: "invalid_token", completion_data: {foo: "bar"}}
    assert_response :unprocessable_entity
  end

  private

  def generate_valid_token(action_id)
    payload = {
      action_id: action_id,
      user_id: @user.id,
      exp: 30.minutes.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
