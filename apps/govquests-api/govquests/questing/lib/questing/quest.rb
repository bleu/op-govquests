# app/models/quest.rb
module Questing
  class Quest
    include AggregateRoot

    def initialize(id)
      @id = id
      @audience = nil
      @quest_type = nil
      @duration = nil
      @difficulty = nil
      @requirements = []
      @reward = {}
      @subquests = []
      @status = "created"
      @progress = {}
    end

    def create(audience, quest_type, duration, difficulty, requirements = [], reward = {}, subquests = [])
      raise "Quest already created" unless @status == "created"

      apply QuestCreated.new(data: {
        quest_id: @id,
        audience: audience,
        quest_type: quest_type,
        duration: duration,
        difficulty: difficulty,
        requirements: requirements,
        reward: reward,
        subquests: subquests
      })
    end

    def associate_action(action_id)
      apply ActionAssociatedWithQuest.new(data: {quest_id: @id, action_id: action_id})
    end

    def update_progress(user_id, progress_measure)
      apply QuestProgressUpdated.new(data: {
        user_id: user_id,
        quest_id: @id,
        progress_measure: progress_measure
      })
    end

    private

    on QuestCreated do |event|
      @audience = event.data[:audience]
      @quest_type = event.data[:quest_type]
      @duration = event.data[:duration]
      @difficulty = event.data[:difficulty]
      @requirements = event.data[:requirements]
      @reward = event.data[:reward]
      @subquests = event.data[:subquests]
      @status = "created"
    end

    on ActionAssociatedWithQuest do |event|
      @actions ||= []
      @actions << event.data[:action_id]
    end

    on QuestProgressUpdated do |event|
      @progress[event.data[:user_id]] = event.data[:progress_measure]
    end
  end
end
