module ActionTracking
  class ActionExecution
    include AggregateRoot

    class AlreadyStartedError < StandardError; end

    class NotStartedError < StandardError; end

    class AlreadyCompletedError < StandardError; end

    class InvalidNonceError < StandardError; end

    class NotCompletedError < StandardError; end

    def initialize(id)
      @id = id
      @quest_id = nil
      @action_id = nil
      @user_id = nil
      @action_type = nil
      @state = "not_started"
      @data = {}
      @nonce = nil
      @started_at = nil
      @completed_at = nil
    end

    def start(quest_id, action_id, action_type, user_id, start_data, nonce)
      raise AlreadyStartedError if started?
      raise AlreadyCompletedError if completed?

      apply ActionExecutionStarted.new(data: {
        execution_id: @id,
        quest_id: quest_id,
        action_id: action_id,
        user_id: user_id,
        action_type: action_type,
        started_at: Time.now,
        start_data: start_data,
        nonce: nonce
      })
    end

    def complete(nonce, completion_data = {})
      raise NotStartedError if @state == "not_started"
      raise InvalidNonceError unless valid_nonce?(nonce)
      raise AlreadyCompletedError if completed?

      apply ActionExecutionCompleted.new(data: {
        execution_id: @id,
        quest_id: @quest_id,
        action_id: @action_id,
        user_id: @user_id,
        completion_data: completion_data
      })
    rescue => e
      raise NotCompletedError.new(e.message)
    end

    def valid_nonce?(nonce)
      @nonce == nonce
    end

    private

    def started?
      @state == "started"
    end

    def completed?
      @state == "completed"
    end

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
