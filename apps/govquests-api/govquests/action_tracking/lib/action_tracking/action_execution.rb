module ActionTracking
  class ActionExecution
    include AggregateRoot

    class AlreadyStartedError < StandardError; end

    class NotStartedError < StandardError; end

    class AlreadyCompletedError < StandardError; end

    class InvalidNonceError < StandardError; end

    def initialize(id)
      @id = id
      @action_id = nil
      @user_id = nil
      @action_type = nil
      @state = "not_started"
      @data = {}
      @nonce = nil
      @started_at = nil
    end

    def start(action_id, action_type, user_id, start_data)
      raise AlreadyStartedError if @state != "not_started"

      nonce = SecureRandom.hex(16)
      strategy = ActionTracking::ActionStrategyFactory.for(action_type)
      data = strategy.start_execution(start_data)
      apply ActionExecutionStarted.new(data: {
        execution_id: @id,
        action_id: action_id,
        user_id: user_id,
        action_type: action_type,
        started_at: Time.now,
        start_data: start_data.merge(data || {}),
        nonce: nonce
      })
    end

    def complete(nonce, completion_data)
      raise InvalidNonceError unless valid_nonce?(nonce)
      raise NotStartedError if @state == "not_started"
      raise AlreadyCompletedError if @state == "completed"

      strategy = ActionTracking::ActionStrategyFactory.for(@action_type)
      data = strategy.complete_execution(completion_data)

      apply ActionExecutionCompleted.new(data: {
        execution_id: @id,
        completion_data: data
      })
    end

    def valid_nonce?(nonce)
      @nonce == nonce
    end

    private

    on ActionExecutionStarted do |event|
      @state = "started"
      @action_id = event.data[:action_id]
      @user_id = event.data[:user_id]
      @action_type = event.data[:action_type]
      @data = event.data[:start_data] || {}
      @nonce = event.data[:nonce]
    end

    on ActionExecutionCompleted do |event|
      @state = "completed"
      @data.merge!(event.data[:completion_data])
    end
  end
end
