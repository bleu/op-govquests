# govquests/action_tracking/lib/action_tracking/action.rb

module ActionTracking
  class ActionExecution
    include AggregateRoot

    attr_reader :id, :action_id, :user_id, :state, :data

    def initialize(id)
      @id = id
      @action_id = nil
      @user_id = nil
      @state = "not_started"
      @data = {}
    end

    def start(action_id, user_id, data)
      raise AlreadyStartedError if @state != "not_started"

      action = Action.load(action_id)
      strategy = ActionTracking::ActionStrategyFactory.for(action.action_type)
      result = strategy.start_execution(data)

      apply ActionExecutionStarted.new(data: {
        execution_id: @id,
        action_id: action_id,
        user_id: user_id,
        action_type: action.action_type,
        started_at: Time.now,
        result: result
      })
    end

    def complete(data)
      raise NotStartedError if @state == "not_started"
      raise AlreadyCompletedError if @state == "completed"

      action = Action.load(@action_id)
      strategy = ActionTracking::ActionStrategyFactory.for(action.action_type)
      result = strategy.complete_execution(data.merge(@data))

      apply ActionExecutionCompleted.new(data: {
        execution_id: @id,
        result: result
      })
    end

    def self.load(execution_id)
      stream_name = "ActionExecution$#{execution_id}"
      execution = new(execution_id)
      execution.load(stream_name)
      execution
    end

    private

    on ActionExecutionStarted do |event|
      @state = "started"
      @action_id = event.data[:action_id]
      @user_id = event.data[:user_id]
      @data = event.data[:result]
    end

    on ActionExecutionCompleted do |event|
      @state = event.data[:result][:status]
      @data.merge!(event.data[:result])
    end
  end
end
