module Gamification
  module Strategies
    class TestBadge < Base
      def verify_completion?
        true
      end
    end
  end
end