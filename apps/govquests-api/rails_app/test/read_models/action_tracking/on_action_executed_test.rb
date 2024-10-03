require "test_helper"

module ActionTracking
  class OnActionExecutedTest < ActiveSupport::TestCase
    def setup
      @handler = OnActionExecuted.new
      @action_log_id = SecureRandom.uuid
      @action_id = SecureRandom.uuid
      @user_id = SecureRandom.uuid
      @timestamp = Time.current
    end

    test "creates a new action log when handling ActionExecuted event" do
      event = ActionExecuted.new(data: {
        action_id: @action_id,
        user_id: @user_id,
        timestamp: @timestamp
      })

      assert_difference "ActionLogReadModel.count", 1 do
        @handler.call(event)
      end

      action_log = ActionLogReadModel.last
      assert_equal @action_id, action_log.action_id
      assert_equal @user_id, action_log.user_id
      assert_equal @timestamp.to_i, action_log.executed_at.to_i
      assert_equal "Executed", action_log.status
    end
  end
end
