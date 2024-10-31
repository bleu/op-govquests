module Questing
  class Quest
    include AggregateRoot

    QuestNotCreatedError = Class.new(StandardError)

    attr_reader :actions, :state, :display_data, :audience

    def initialize(id)
      @id = id
      @actions = []
      @state = :draft
      @reward_pools = {}
    end

    def create(display_data, audience)
      display_data ||= {}

      apply QuestCreated.new(data: {
        quest_id: @id,
        display_data: display_data,
        audience: audience
      })
    end

    def associate_reward_pool(pool_id, reward_definition)
      apply RewardPoolAssociated.new(data: {
        quest_id: @id,
        pool_id: pool_id,
        reward_definition: reward_definition
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

    on RewardPoolAssociated do |event|
      @reward_pools[event.data[:reward_definition][:type]] = event.data[:pool_id]
    end

    on QuestCreated do |event|
      @state = :created
      @display_data = event.data[:display_data]
      @audience = event.data[:audience]
    end

    on ActionAssociatedWithQuest do |event|
      @actions << {id: event.data[:action_id], position: event.data[:position]}
    end
  end
end
