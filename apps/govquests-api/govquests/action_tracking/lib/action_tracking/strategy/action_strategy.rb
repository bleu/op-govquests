module ActionTracking
  class ActionStrategy
    def create_action(data)
      action_data(data)
    end

    def start_execution(data)
      {message: "Action execution started"}
    end

    def complete_execution(data)
      if verify_completion(data)
        {status: "completed", message: "Action successfully completed"}
      else
        {status: "failed", message: "Action completion criteria not met"}
      end
    end

    private

    def action_type
      raise NotImplementedError, "#{self.class} must implement #action_type"
    end

    def description
      raise NotImplementedError, "#{self.class} must implement #description"
    end

    def action_data(data)
      raise NotImplementedError, "#{self.class} must implement #action_data"
    end

    def verify_completion(data)
      raise NotImplementedError, "#{self.class} must implement #verify_completion"
    end
  end
end
