require_relative "base"

module ActionTracking
  module Strategies
    class ReadContentInapp < Base
      def can_complete?
        true
      end
    end
  end
end
