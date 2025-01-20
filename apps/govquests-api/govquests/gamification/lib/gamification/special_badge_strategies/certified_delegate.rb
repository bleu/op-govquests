module Gamification
  module Strategies
    class CertifiedDelegate < Base
      def verify_completion?
        true
      end
    end
  end
end