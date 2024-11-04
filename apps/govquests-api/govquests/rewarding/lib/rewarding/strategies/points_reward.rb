require_relative "base"
module Rewarding
  module Strategies
    class PointsReward < Base
      def auto_complete?
        true
      end

      def on_complete_claim
        {points: reward_definition.fetch("amount")}
      end
    end
  end
end
