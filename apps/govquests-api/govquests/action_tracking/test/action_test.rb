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
      action_type = "ReadDocument"
      completion_criteria = {document_url: "https://example.com/survey"}

      @action.create(content, action_type, completion_criteria)

      events = @action.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of ActionCreated, event
      assert_equal @action_id, event.data[:action_id]
      assert_equal content, event.data[:content]
      assert_equal action_type, event.data[:action_type]
      assert_equal completion_criteria, event.data[:completion_criteria]
    end

    def test_complete_an_action
      @action.create("Complete survey", "ReadDocument", {document_url: "https://example.com/survey"})
      user_id = SecureRandom.uuid
      completion_data = {result: "success"}

      @action.complete(user_id, completion_data)

      events = @action.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of ActionExecuted, event
      assert_equal @action_id, event.data[:action_id]
      assert_equal user_id, event.data[:user_id]
      assert_equal completion_data, event.data[:completion_data]
    end
  end
end
