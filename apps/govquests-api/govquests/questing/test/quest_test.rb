# govquests/questing/test/quest_test.rb
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
      quest_type = "Standard"
      audience = "AllUsers"
      rewards = [{type: "points", value: 100}]
      display_data = {title: "Governance 101", intro: "Learn about governance basics"}

      @quest.create(display_data, quest_type, audience, rewards)

      events = @quest.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of QuestCreated, event
      assert_equal @quest_id, event.data[:quest_id]
      assert_equal display_data, event.data[:display_data]
      assert_equal quest_type, event.data[:quest_type]
      assert_equal audience, event.data[:audience]
      assert_equal rewards, event.data[:rewards]
    end

    def test_associate_an_action_with_a_quest
      @quest.create({title: "Test Quest", intro: "Test Intro"}, "Standard", "AllUsers", [{type: "points", value: 10}])
      action_id = SecureRandom.uuid
      position = 1

      @quest.associate_action(action_id, position)

      events = @quest.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of ActionAssociatedWithQuest, event
      assert_equal @quest_id, event.data[:quest_id]
      assert_equal action_id, event.data[:action_id]
      assert_equal position, event.data[:position]
    end
  end
end
