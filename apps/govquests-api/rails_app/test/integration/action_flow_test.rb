# rails_app/test/integration/action_flow_test.rb
require "test_helper"

class ActionFlowTest < IntegrationTest
  test "create and execute an action" do
    # Create a new action
    action_id = SecureRandom.uuid
    post "/actions", params: {
      action_id: action_id,
      content: "Complete Governance Survey",
      action_type: "ReadDocument",
      completion_criteria: {document_url: "https://example.com/survey"}
    }
    assert_response :success
    assert_equal 1, ActionReadModel.count

    action = ActionReadModel.find_by(action_id: action_id)
    assert_not_nil action
    assert_equal "Complete Governance Survey", action.content
    assert_equal "ReadDocument", action.action_type
    assert_equal({"document_url" => "https://example.com/survey"}, action.completion_criteria)

    # Execute the action
    user = UserReadModel.first
    SecureRandom.uuid
    post "/actions/execute", params: {
      action_id: action_id,
      user_id: user.user_id,
      timestamp: Time.current,
      completion_data: {result: "success"}
    }
    assert_response :success
    assert_equal 1, ActionLogReadModel.count

    action_log = ActionLogReadModel.last
    assert_equal action_id, action_log.action_id
    assert_equal user.user_id, action_log.user_id
    assert_equal "Executed", action_log.status
    assert_equal "success", action_log.completion_data["result"]
  end
end
