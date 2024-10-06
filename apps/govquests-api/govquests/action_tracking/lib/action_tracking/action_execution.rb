module ActionTracking
  class ActionExecution
    include AggregateRoot

    class AlreadyStartedError < StandardError; end

    class NotStartedError < StandardError; end

    class AlreadyCompletedError < StandardError; end

    class ExecutionExpiredError < StandardError; end

    class InvalidSaltError < StandardError; end

    EXPIRATION_TIME_IN_SECONDS = 30 * 60

    def initialize(id)
      @id = id
      @action_id = nil
      @user_id = nil
      @action_type = nil
      @state = "not_started"
      @data = {}
      @salt = nil
      @started_at = nil
    end

    def start(action_id, action_type, user_id, data)
      raise AlreadyStartedError if @state != "not_started"

      salt = SecureRandom.hex(16)
      strategy = ActionTracking::ActionStrategyFactory.for(action_type)
      data = strategy.start_execution(data)

      apply ActionExecutionStarted.new(data: {
        execution_id: @id,
        action_id: action_id,
        user_id: user_id,
        action_type: action_type,
        started_at: Time.now,
        data: data,
        salt: salt
      })
    end

    def complete(salt, data)
      raise InvalidSaltError unless valid_salt?(salt)
      raise NotStartedError if @state == "not_started"
      raise AlreadyCompletedError if @state == "completed"
      raise ExecutionExpiredError if expired?

      strategy = ActionTracking::ActionStrategyFactory.for(@action_type)
      data = strategy.complete_execution(data.merge(@data))

      apply ActionExecutionCompleted.new(data: {
        execution_id: @id,
        data: data
      })
    end

    def expire
      unless expired? && @state != "expired"
        apply ActionExecutionExpired.new(data: {
          execution_id: @id,
          expired_at: Time.now
        })
      end
    end

    def expired?
      @started_at && Time.now - @started_at > EXPIRATION_TIME_IN_SECONDS
    end

    def valid_salt?(salt)
      @salt == salt && !expired?
    end

    private

    on ActionExecutionStarted do |event|
      @state = "started"
      @action_id = event.data[:action_id]
      @user_id = event.data[:user_id]
      @action_type = event.data[:action_type]
      @data = event.data[:data] || {}
      @salt = event.data[:salt]
      @started_at = event.data[:started_at]
    end

    on ActionExecutionCompleted do |event|
      @state = "completed"
      @data.merge!(event.data[:data])
    end

    on ActionExecutionExpired do |event|
      @state = "expired"
      @expired_at = event.data[:expired_at]
    end
  end
end
