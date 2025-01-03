module ActionTracking
  class ActionExecutionStrategyFactory
    class UnknownActionTypeError < StandardError; end

    class << self
      def strategies
        @strategies ||= {}
      end

      def register(action_type, strategy_class)
        strategies[action_type] = strategy_class
      end

      def for(action_type, **dependencies)
        strategy_name = action_type.to_s.camelize
        strategy_class = "ActionTracking::Strategies::#{strategy_name}".constantize

        register(action_type, strategy_class)

        strategy_class.new(**dependencies)
      rescue NameError
        raise UnknownActionTypeError, "Unknown action type: #{action_type}"
      end
    end
  end
end
