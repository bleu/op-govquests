module Questing
  class UserQuest
    include AggregateRoot

    QuestNotStartedError = Class.new(StandardError)
    QuestAlreadyStartedError = Class.new(StandardError)
    QuestAlreadyCompletedError = Class.new(StandardError)

    def initialize(id)
      @id = id
      @quest_id = nil
      @user_id = nil
      @state = :not_started
      @progress = {}
      @rewards = []
    end

    def start(quest_id, user_id)
      raise QuestAlreadyStartedError if @state == :started
      raise QuestAlreadyCompletedError if @state == :completed

      apply QuestStarted.new(data: {
        user_quest_id: @id,
        quest_id: quest_id,
        user_id: user_id
      })
    end

    def complete
      raise QuestNotStartedError unless @state == :started

      apply QuestCompleted.new(data: {
        user_quest_id: @id,
        quest_id: @quest_id,
        user_id: @user_id,
        rewards: @rewards
      })
    end

    def add_progress(action_id, data)
      raise QuestNotStartedError unless @state == :started

      apply QuestProgressUpdated.new(data: {
        user_quest_id: @id,
        action_id: action_id,
        data: data
      })
    end

    def add_reward(reward)
      @rewards << reward
    end

    private

    on QuestStarted do |event|
      @state = :started
      @quest_id = event.data[:quest_id]
      @user_id = event.data[:user_id]
    end

    on QuestCompleted do |event|
      @state = :completed
      @rewards = event.data[:rewards]
    end

    on QuestProgressUpdated do |event|
      @progress[event.data[:action_id]] = event.data[:data]
    end
  end
end
