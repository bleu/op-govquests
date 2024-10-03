require "test_helper"

module ActionTracking
  class OnActionCreatedTest < ActiveSupport::TestCase
    def setup
      @handler = OnActionCreated.new
      @action_id = SecureRandom.uuid
      @content = "Complete survey"
      @priority = "High"
      @channel = "Email"
    end

    test "creates a new action when handling ActionCreated event" do
      event = ActionCreated.new(data: {
        action_id: @action_id,
        content: @content,
        priority: @priority,
        channel: @channel
      })

      assert_difference "ActionReadModel.count", 1 do
        @handler.call(event)
      end

      action = ActionReadModel.find_by(action_id: @action_id)
      assert_equal @content, action.content
      assert_equal @priority, action.priority
      assert_equal @channel, action.channel
      assert_equal "Created", action.status
    end
  end
end
