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
      action_type = "read_document"
      action_data = {
        document_url: "https://example.com/survey"
      }
      display_data = {
        content: "Read a document"
      }

      @action.create(action_type, action_data, display_data)

      events = @action.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first

      assert_instance_of ActionCreated, event
      assert_equal @action_id, event.data[:action_id]
      assert_equal action_type, event.data[:action_type]
      assert_kind_of Hash, event.data[:action_data]

      assert_equal display_data[:content], event.data[:display_data][:content]
      assert_equal action_data[:document_url], event.data[:action_data][:document_url]
    end
  end
end
