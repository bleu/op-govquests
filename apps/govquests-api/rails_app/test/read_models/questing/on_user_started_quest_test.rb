require "test_helper"

module Questing
  class OnUserStartedQuestTest < ActiveSupport::TestCase
    def setup
      @handler = Questing::OnUserStartedQuest.new
      @quest_id = SecureRandom.uuid
      @user_id = SecureRandom.uuid
    end

    test "creates or updates user quest when handling UserStartedQuest event" do
      event = Questing::UserStartedQuest.new(data: {
        quest_id: @quest_id,
        user_id: @user_id
      })

      assert_difference "UserQuest.count", 1 do
        @handler.call(event)
      end

      user_quest = UserQuest.find_by(quest_id: @quest_id, user_id: @user_id)
      assert_equal "started", user_quest.status
      assert_not_nil user_quest.started_at
    end
  end
end
