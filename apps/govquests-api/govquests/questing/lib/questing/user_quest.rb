module Questing
  class UserQuest
    include AggregateRoot

    QuestNotStartedError = Class.new(StandardError)
    QuestAlreadyStartedError = Class.new(StandardError)
    QuestAlreadyCompletedError = Class.new(StandardError)
    ActionsNotCompletedError = Class.new(StandardError)
    InvalidActionError = Class.new(StandardError)

    def initialize(id)
      @id = id
      @quest_id = nil
      @user_id = nil
      @state = :not_started
      @actions = []
      @progress = {}
    end

    def start(quest_id, user_id, actions)
      raise QuestAlreadyStartedError if @state == :started
      raise QuestAlreadyCompletedError if @state == :completed

      apply QuestStarted.new(data: {
        user_quest_id: @id,
        quest_id: quest_id,
        user_id: user_id,
        actions: actions
      })
    end

    def add_progress(action_id, data)
      raise QuestNotStartedError unless @state == :started

      unless @actions.include?(action_id)
        raise InvalidActionError, "Action #{action_id} is not part of this quest."
      end

      apply QuestProgressUpdated.new(data: {
        user_quest_id: @id,
        action_id: action_id,
        data: data
      })

      if all_actions_completed?
        complete
      end
    end

    def complete
      raise QuestNotStartedError unless @state == :started
      raise QuestAlreadyCompletedError if @state == :completed
      raise ActionsNotCompletedError unless all_actions_completed?

      apply QuestCompleted.new(data: {
        user_quest_id: @id,
        quest_id: @quest_id,
        user_id: @user_id
      })
    end

    private

    def all_actions_completed?
      (@actions - @progress.keys).empty?
    end

    on QuestStarted do |event|
      @state = :started
      @quest_id = event.data[:quest_id]
      @user_id = event.data[:user_id]
      @actions = event.data[:actions]
      @progress = {}
    end

    on QuestProgressUpdated do |event|
      @progress[event.data[:action_id]] = event.data[:data]
    end

    on QuestCompleted do |event|
      @state = :completed
    end
  end
end
