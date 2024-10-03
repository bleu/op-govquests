require_relative "test_helper"

module Questing
  class QuestTest < Test
    cover "Questing::Quest"

    def setup
      super
      @quest_id = SecureRandom.uuid
      @quest = Quest.new(@quest_id)
    end

    def test_create_a_new_quest
      audience = "AllUsers"
      quest_type = "Standard"
      duration = 7
      difficulty = "Medium"
      requirements = [{quest_type: "action", description: "Complete action X"}]
      reward = {quest_type: "points", value: 100}
      subquests = [{id: SecureRandom.uuid, description: "Subquest 1"}]

      @quest.create(audience, quest_type, duration, difficulty, requirements, reward, subquests)

      events = @quest.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of QuestCreated, event
      assert_equal @quest_id, event.data[:quest_id]
      assert_equal audience, event.data[:audience]
      assert_equal quest_type, event.data[:quest_type]
      assert_equal duration, event.data[:duration]
      assert_equal difficulty, event.data[:difficulty]
      assert_equal requirements, event.data[:requirements]
      assert_equal reward, event.data[:reward]
      assert_equal subquests, event.data[:subquests]
    end

    def test_cannot_create_an_already_created_quest
      @quest.create("AllUsers", "Standard", 7, "Medium")

      assert_raises(RuntimeError, "Quest already created") do
        @quest.create("Delegates", "Epic", 30, "Hard")
      end
    end

    def test_associate_an_action_with_a_quest
      @quest.create("AllUsers", "Standard", 7, "Medium")
      action_id = SecureRandom.uuid

      @quest.associate_action(action_id)

      events = @quest.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of ActionAssociatedWithQuest, event
      assert_equal @quest_id, event.data[:quest_id]
      assert_equal action_id, event.data[:action_id]
    end
  end
end
