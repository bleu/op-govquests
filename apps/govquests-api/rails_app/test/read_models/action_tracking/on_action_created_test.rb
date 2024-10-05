require "test_helper"

module ActionTracking
  class OnActionCreatedTest < ActiveSupport::TestCase
    test "should create action read model on ActionCreated event" do
      event = ActionCreated.new(data: {
        action_id: "test_action_id",
        action_type: "test_type",
        action_data: {foo: "bar"},
        content: "Test content"
      })

      assert_difference "ActionReadModel.count", 1 do
        OnActionCreated.new.call(event)
      end

      action = ActionReadModel.last
      assert_equal "test_action_id", action.action_id
      assert_equal "test_type", action.action_type
      assert_equal({"foo" => "bar"}, action.action_data)
      assert_equal "Test content", action.content
    end
  end
end
