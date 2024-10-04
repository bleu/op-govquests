module ActionTracking
  class Action
    include AggregateRoot

    def initialize(id)
      @id = id
      @content = nil
      @action_type = nil
      @completion_criteria = {}
      @completed = false
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
      raise "Action already completed" if @completed

      apply ActionExecuted.new(data: {
        action_id: @id,
        user_id: user_id,
        completion_data: completion_data
      })
    end

    private

    on ActionCreated do |event|
      @content = event.data[:content]
      @action_type = event.data[:action_type]
      @completion_criteria = event.data[:completion_criteria]
    end

    on ActionExecuted do |event|
      @completed = true
      # Additional logic for completion can be added here
    end
  end
end
