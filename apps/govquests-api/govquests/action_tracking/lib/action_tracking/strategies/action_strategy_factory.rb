require_relative "gitcoin_score_action_strategy"
require_relative "read_document_action_strategy"

module ActionTracking
  class ActionStrategyFactory
    STRATEGIES = {
      "gitcoin_score" => GitcoinScoreActionStrategy,
      "read_document" => ReadDocumentActionStrategy
    }.freeze

    def self.for(action_type, dependencies = {})
      strategy_class = STRATEGIES[action_type]
      raise UnknownActionTypeError, "Unknown action type: #{action_type}" unless strategy_class

      strategy_class.new(**dependencies)
    end
  end

  class UnknownActionTypeError < StandardError; end
end
