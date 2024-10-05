require_relative "strategy/action_strategy_factory"
module ActionTracking
  class Action
    include AggregateRoot

    def initialize(id)
      @id = id
      @state = "draft"
      @data = {}
      @action_type = nil
    end

    def create(action_type, data)
      raise AlreadyCreatedError if @state != "draft"

      strategy = ActionTracking::ActionStrategyFactory.for(action_type)
      action_data = strategy.create_action(data)

      apply ActionCreated.new(data: {
        action_id: @id,
        action_type: action_type,
        action_data: action_data
      })
    end

    def self.load(action_id)
      stream_name = "Action$#{action_id}"
      action = new(action_id)

      action.load(stream_name)
      action
    end

    attr_reader :action_type

    private

    on ActionCreated do |event|
      @state = "created"
      @data = event.data[:action_data]
      @action_type = event.data[:action_type]
    end
  end
end
