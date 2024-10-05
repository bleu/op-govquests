require "test_helper"

module Questing
  class OnQuestCreatedTest < ActiveSupport::TestCase
    def setup
      @handler = Questing::OnQuestCreated.new
      @quest_id = SecureRandom.uuid
      @title = "Governance 101"
      @intro = "Learn about governance basics"
      @quest_type = "Onboarding"
      @audience = "AllUsers"
      @rewards = [{type: "Points", amount: 50}.transform_keys(&:to_s)]
    end

    test "creates a new quest when handling QuestCreated event" do
      event = Questing::OnQuestCreated.new(data: {
        quest_id: @quest_id,
        display_data: {

          title: @title,
          intro: @intro
        },
        quest_type: @quest_type,
        audience: @audience,
        rewards: @rewards
      })

      assert_difference -> { QuestReadModel.count }, 1 do
        @handler.call(event)
      end

      quest = QuestReadModel.find_by(quest_id: @quest_id)
      assert_equal @title, quest.title
      assert_equal @intro, quest.intro
      assert_equal @quest_type, quest.quest_type
      assert_equal @audience, quest.audience
      assert_equal @rewards, quest.rewards
      assert_equal "created", quest.status
    end
  end
end
