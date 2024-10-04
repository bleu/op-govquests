require "test_helper"

module ActionTracking
  class OnActionCreatedTest < ActiveSupport::TestCase
    def setup
      @handler = OnActionCreated.new
      @action_id = SecureRandom.uuid
      @content = "Complete survey"
      @action_type = "ReadDocument"
      @completion_criteria = {document_url: "https://example.com/survey"}.transform_keys(&:to_s)
    end

    test "creates a new action when handling ActionCreated event" do
      event = ActionCreated.new(data: {
        action_id: @action_id,
        content: @content,
        action_type: @action_type,
        completion_criteria: @completion_criteria
      })

      assert_difference "ActionReadModel.count", 1 do
        @handler.call(event)
      end

      action = ActionReadModel.find_by(action_id: @action_id)
      assert_equal @content, action.content
      assert_equal @action_type, action.action_type
      assert_equal @completion_criteria, action.completion_criteria
    end
  end
end
