module ActionTracking
  class Action
    include AggregateRoot

    def initialize(id)
      @id = id
      @content = nil
      @priority = nil
      @channel = nil
      @executions = []
    end

    def create(content, priority, channel)
      apply ActionCreated.new(data: {
        action_id: @id,
        content: content,
        priority: priority,
        channel: channel
      })
    end

    def execute(user_id, timestamp)
      apply ActionExecuted.new(data: {
        action_id: @id,
        user_id: user_id,
        timestamp: timestamp
      })
    end

    private

    on ActionCreated do |event|
      @content = event.data[:content]
      @priority = event.data[:priority]
      @channel = event.data[:channel]
    end

    on ActionExecuted do |event|
      @executions << {
        user_id: event.data[:user_id],
        timestamp: event.data[:timestamp]
      }
    end
  end
end
