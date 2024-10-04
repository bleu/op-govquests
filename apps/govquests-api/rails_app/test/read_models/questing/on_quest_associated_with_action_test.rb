require "test_helper"

module Questing
  class OnActionAssociatedWithQuestTest < ActiveSupport::TestCase
    def setup
      @handler = Questing::OnActionAssociatedWithQuest.new
      @quest_id = SecureRandom.uuid
      @action_id = SecureRandom.uuid
      @position = 1

      QuestReadModel.create!(quest_id: @quest_id, display_data: {title: "Test Quest", intro: "Test Intro"}, quest_type: "Test", audience: "All", status: "created")
      ActionTracking::ActionReadModel.create!(action_id: @action_id, display_data: {content: "Test Action"}, action_type: "Test", completion_criteria: {})
    end

    test "associates an action with a quest when handling ActionAssociatedWithQuest event" do
      event = ActionAssociatedWithQuest.new(data: {
        quest_id: @quest_id,
        action_id: @action_id,
        position: @position
      })

      assert_difference "QuestActionReadModel.count", 1 do
        @handler.call(event)
      end

      quest_action = QuestActionReadModel.last
      assert_equal @quest_id, quest_action.quest_id
      assert_equal @action_id, quest_action.action_id
      assert_equal @position, quest_action.position
    end
  end
end
