module ActionTracking
  class Action
    include AggregateRoot

    def initialize(id)
      @id = id
    end

    def create(content, action_type, completion_criteria)
      apply ActionCreated.new(data: {
        action_id: @id,
        content: content,
        action_type: action_type,
        completion_criteria: completion_criteria
      })
    end

    def complete(user_id, completion_data)
      apply ActionExecuted.new(data: {
        action_id: @id,
        user_id: user_id,
        completion_data: completion_data
      })
    end

    on ActionCreated do |event|
      @content = event.data[:content]
      @action_type = event.data[:action_type]
      @completion_criteria = event.data[:completion_criteria]
    end

    on ActionExecuted do |event|
      # Handle completion logic if needed
    end
  end
end
