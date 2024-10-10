module Questing
  class Quest
    include AggregateRoot

    def initialize(id)
      @id = id
      @actions = []
      @state = :created
    end

    def create(display_data, quest_type, audience, rewards)
      apply QuestCreated.new(data: {
        quest_id: @id,
        display_data: display_data,
        quest_type: quest_type,
        audience: audience,
        rewards: rewards
      })
    end

    def associate_action(action_id, position)
      apply ActionAssociatedWithQuest.new(data: {
        quest_id: @id,
        action_id: action_id,
        position: position
      })
    end

    on QuestCreated do |event|
      @display_data = event.data[:display_data]
      @quest_type = event.data[:quest_type]
      @audience = event.data[:audience]
      @rewards = event.data[:rewards]
    end

    on ActionAssociatedWithQuest do |event|
      @actions << {id: event.data[:action_id], position: event.data[:position]}
    end
  end
end
