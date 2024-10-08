require_relative "test_helper"

module ActionTracking
  class ActionExecutionTest < Test
    cover "ActionTracking::ActionExecution"

    def setup
      super
      @action_id = SecureRandom.uuid
      @user_id = SecureRandom.uuid
      @execution_id = ActionTracking.generate_execution_id(action_id, user_id)
      @execution = ActionExecution.new(@execution_id)
      @action_type = "read_document"
    end

    def test_start_action_execution
      data = {document_url: "https://example.com/document"}

      @execution.start(@action_id, @action_type, @user_id, data)

      events = @execution.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of ActionExecutionStarted, event
      assert_equal @execution_id, event.data[:execution_id]
      assert_equal @user_id, event.data[:user_id]
      assert_kind_of Hash, event.data[:start_data]
    end

    def test_complete_action_execution
      @execution.start(@action_id, @action_type, @user_id, {document_url: "https://example.com/document"})
      completion_data = {data: "success"}

      events = @execution.unpublished_events.to_a

      start_event = events.first
      @execution.complete(start_event.data[:nonce], completion_data)

      events = @execution.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of ActionExecutionCompleted, event
      assert_equal @execution_id, event.data[:execution_id]
      assert_kind_of Hash, event.data[:completion_data]
    end
  end
end
