require_relative "gitcoin_score"
require_relative "read_document"

module ActionTracking
  class ActionExecutionStrategyFactory
    class UnknownActionTypeError < StandardError; end

    @strategies = {}

    class << self
      attr_reader :strategies

      def register(action_type, strategy_class)
        @strategies[action_type] = strategy_class
      end

      def for(action_type, **dependencies)
        strategy_class = @strategies[action_type]
        raise UnknownActionTypeError, "Unknown action type: #{action_type}" unless strategy_class

        strategy_class.new(**dependencies)
      end
    end
  end
end

ActionTracking::ActionExecutionStrategyFactory.register("gitcoin_score", ActionTracking::Strategies::GitcoinScore)
ActionTracking::ActionExecutionStrategyFactory.register("read_document", ActionTracking::Strategies::ReadDocument)
