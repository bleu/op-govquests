require_relative "base"

module ActionTracking
  module Strategies
    class ReadDocument < Base
      def can_complete?
        false
      end
    end
  end
end
