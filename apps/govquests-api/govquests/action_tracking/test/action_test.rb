require_relative "test_helper"

module ActionTracking
  class ActionTest < Test
    cover "ActionTracking::Action"

    def setup
      super
      @action_id = SecureRandom.uuid
      @action = Action.new(@action_id)
    end

    def test_create_a_new_action
      content = "Complete survey"
      priority = "High"
      channel = "Email"

      @action.create(content, priority, channel)

      events = @action.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of ActionCreated, event
      assert_equal @action_id, event.data[:action_id]
      assert_equal content, event.data[:content]
      assert_equal priority, event.data[:priority]
      assert_equal channel, event.data[:channel]
    end

    def test_execute_an_action
      @action.create("Complete survey", "High", "Email")
      user_id = SecureRandom.uuid
      timestamp = Time.now

      @action.execute(user_id, timestamp)

      events = @action.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of ActionExecuted, event
      assert_equal @action_id, event.data[:action_id]
      assert_equal user_id, event.data[:user_id]
      assert_equal timestamp, event.data[:timestamp]
    end
  end
end
