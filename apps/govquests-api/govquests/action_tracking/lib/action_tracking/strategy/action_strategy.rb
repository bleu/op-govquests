module ActionTracking
  class ActionStrategy
    def initialize(action, event)
      raise NotImplementedError, "Subclasses must implement the `initialize` method."
    end

    def execute(action, event)
      raise NotImplementedError, "Subclasses must implement the `execute` method."
    end

    def complete(action, event)
      raise NotImplementedError, "Subclasses must implement the `complete` method."
    end
  end
end
