module Questing
  class Quest
    include AggregateRoot

    QuestNotCreatedError = Class.new(StandardError)

    attr_reader :rewards, :actions, :state, :display_data, :quest_type, :audience

    def initialize(id)
      @id = id
      @actions = []
      @state = :draft
      @rewards = []
    end

    def create(display_data, quest_type, audience, rewards)
      display_data ||= {}
      rewards ||= []

      apply QuestCreated.new(data: {
        quest_id: @id,
        display_data: display_data,
        quest_type: quest_type,
        audience: audience,
        rewards: rewards
      })
    end

    def associate_action(action_id, position)
      raise QuestNotCreatedError, "Cannot associate actions before quest creation" unless @state == :created

      apply ActionAssociatedWithQuest.new(data: {
        quest_id: @id,
        action_id: action_id,
        position: position
      })
    end

    private

    on QuestCreated do |event|
      @state = :created
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
