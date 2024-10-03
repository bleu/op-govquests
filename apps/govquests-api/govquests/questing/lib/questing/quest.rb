module Questing
  class Quest
    include AggregateRoot

    def initialize(id)
      @id = id
      @status = "created"
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
      apply ActionAssociatedWithQuest.new(data: {
        quest_id: @id,
        action_id: action_id
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
      @status = "active"  # Change status to prevent re-creation
    end

    on ActionAssociatedWithQuest do |event|
      @actions ||= []
      @actions << event.data[:action_id]
    end
  end
end
