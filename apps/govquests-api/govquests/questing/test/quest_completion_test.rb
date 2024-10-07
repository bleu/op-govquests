require_relative "test_helper"

module Questing
  class QuestCompletionTest < Test
    cover "Questing::Quest"

    def setup
      super
      @quest_id = SecureRandom.uuid
      @quest = Quest.new(@quest_id)
      @quest.create({title: "Test Quest"}, "Standard", "AllUsers", [{type: "points", value: 100}])
    end

    def test_start_quest
      user_id = SecureRandom.uuid

      @quest.start(user_id)

      events = @quest.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of QuestStarted, event
      assert_equal @quest_id, event.data[:quest_id]
      assert_equal user_id, event.data[:user_id]
    end

    def test_complete_quest
      user_id = SecureRandom.uuid
      @quest.start(user_id)

      @quest.complete(user_id)

      events = @quest.unpublished_events.to_a
      assert_equal 3, events.size
      event = events.last
      assert_instance_of QuestCompleted, event
      assert_equal @quest_id, event.data[:quest_id]
      assert_equal user_id, event.data[:user_id]
    end

    def test_cannot_complete_unstarted_quest
      user_id = SecureRandom.uuid

      assert_raises(Questing::Quest::QuestNotStartedError) do
        @quest.complete(user_id)
      end
    end

    def test_cannot_start_already_completed_quest
      user_id = SecureRandom.uuid
      @quest.start(user_id)
      @quest.complete(user_id)

      assert_raises(Questing::Quest::QuestAlreadyCompletedError) do
        @quest.start(user_id)
      end
    end

    def test_cannot_start_already_started_quest
      user_id = SecureRandom.uuid
      @quest.start(user_id)

      assert_raises(Questing::Quest::QuestAlreadyStartedError) do
        @quest.start(user_id)
      end
    end
  end
end
