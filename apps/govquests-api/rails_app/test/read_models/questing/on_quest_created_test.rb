require "test_helper"

module Questing
  class OnQuestCreatedTest < ActiveSupport::TestCase
    def setup
      @handler = Questing::OnQuestCreated.new
      @quest_id = SecureRandom.uuid
      @audience = "AllUsers"
      @quest_type = "Standard"
      @duration = 7
      @difficulty = "Medium"
      @requirements = [ { "quest_type" => "action", "description" => "Complete action X" } ]
      @reward = { "quest_type" => "points", "value" => 100 }
      @subquests = [ { "id" => SecureRandom.uuid, "description" => "Subquest 1" } ]
    end

    test "creates a new quest when handling QuestCreated event" do
      event = QuestCreated.new(data: {
        quest_id: @quest_id,
        audience: @audience,
        quest_type: @quest_type,
        duration: @duration,
        difficulty: @difficulty,
        requirements: @requirements,
        reward: @reward,
        subquests: @subquests
      })

      assert_difference -> { QuestReadModel.count }, 1 do
        @handler.call(event)
      end

      quest = QuestReadModel.find_by(quest_id: @quest_id)
      assert_equal @audience, quest.audience
      assert_equal @quest_type, quest.quest_type
      assert_equal @duration, quest.duration
      assert_equal @difficulty, quest.difficulty
      assert_equal @requirements, quest.requirements
      assert_equal @reward, quest.reward
      assert_equal @subquests, quest.subquests
      assert_equal "created", quest.status
    end

    test "updates existing quest when handling QuestCreated event" do
      existing_quest = QuestReadModel.create!(
        quest_id: @quest_id,
        audience: "Delegates",
        quest_type: "Epic",
        duration: 30,
        difficulty: "Hard",
        requirements: [],
        reward: {},
        subquests: [],
        status: "archived"
      )

      event = QuestCreated.new(data: {
        quest_id: @quest_id,
        audience: @audience,
        quest_type: @quest_type,
        duration: @duration,
        difficulty: @difficulty,
        requirements: @requirements,
        reward: @reward,
        subquests: @subquests
      })

      assert_no_difference -> { QuestReadModel.count } do
        @handler.call(event)
      end

      existing_quest.reload
      assert_equal @audience, existing_quest.audience
      assert_equal @quest_type, existing_quest.quest_type
      assert_equal @duration, existing_quest.duration
      assert_equal @difficulty, existing_quest.difficulty
      assert_equal @requirements, existing_quest.requirements
      assert_equal @reward, existing_quest.reward
      assert_equal @subquests, existing_quest.subquests
      assert_equal "created", existing_quest.status
    end
  end
end
