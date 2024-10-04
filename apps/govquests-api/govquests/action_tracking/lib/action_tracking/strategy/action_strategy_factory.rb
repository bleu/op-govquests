# lib/action_tracking/strategy/action_strategy_factory.rb
module ActionTracking
  class ActionStrategyFactory
    STRATEGIES = {
      "gitcoin_score" => GitcoinScoreActionStrategy
    }.freeze

    def self.for(action_type, action, event)
      strategy_class = STRATEGIES[action_type]
      raise "Unknown action type: #{action_type}" unless strategy_class

      strategy_class.new(action, event)
    end
  end
end
