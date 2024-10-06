module ActionTracking
  class ActionExecution
    include AggregateRoot

    attr_reader :id, :action_id, :user_id, :state, :data

    def initialize(id)
      @id = id
      @action_id = nil
      @user_id = nil
      @action_type = nil
      @state = "not_started"
      @data = {}
    end

    def start(action_id, action_type, user_id, data)
      raise AlreadyStartedError if @state != "not_started"

      strategy = ActionTracking::ActionStrategyFactory.for(action_type)
      data = strategy.start_execution(data)

      apply ActionExecutionStarted.new(data: {
        execution_id: @id,
        action_id: action_id,
        user_id: user_id,
        action_type: action_type,
        started_at: Time.now,
        data: data
      })
    end

    def complete(data)
      raise NotStartedError if @state == "not_started"
      raise AlreadyCompletedError if @state == "completed"

      strategy = ActionTracking::ActionStrategyFactory.for(@action_type)
      data = strategy.complete_execution(data.merge(@data))

      apply ActionExecutionCompleted.new(data: {
        execution_id: @id,
        data: data
      })
    end

    private

    on ActionExecutionStarted do |event|
      @state = "started"
      @action_id = event.data[:action_id]
      @user_id = event.data[:user_id]
      @action_type = event.data[:action_type]
      @data = event.data[:data]
    end

    on ActionExecutionCompleted do |event|
      @state = event.data[:data][:status]
      @data.merge!(event.data[:data])
    end
  end
end
