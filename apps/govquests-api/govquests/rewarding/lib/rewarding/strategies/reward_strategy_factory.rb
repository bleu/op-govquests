require_relative "token_reward"
require_relative "points_reward"
module Rewarding
  class RewardStrategyFactory
    class UnknownRewardType < StandardError; end

    @strategies = {}
    @dependencies = {}

    class << self
      attr_reader :strategies, :dependencies

      def register(reward_type, strategy_class)
        @strategies[reward_type] = strategy_class
      end

      def configure(dependencies)
        @dependencies = dependencies
      end

      def for(reward_type, **args)
        strategy_class = @strategies[reward_type]
        raise UnknownRewardType, "Unknown reward type: #{reward_type}" unless strategy_class

        strategy_class.new(**args.merge(@dependencies))
      end
    end
  end
end

Rewarding::RewardStrategyFactory.register("Token", Rewarding::Strategies::TokenReward)
Rewarding::RewardStrategyFactory.register("Points", Rewarding::Strategies::PointsReward)
