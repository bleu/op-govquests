module Gamification
  class SpecialBadgeStrategyFactory
    class UnknownSpecialBadgeTypeError < StandardError; end

    class << self
      def strategies
        @strategies ||= {}
      end

      def for(badge_type, **dependencies)
        strategy_name = badge_type.to_s.camelize
        strategy_class = "Gamification::Strategies::#{strategy_name}".constantize

        puts "Looking for class: Gamification::Strategies::#{strategy_name}" # Debug
        
        strategy_class.new(**dependencies)
      rescue NameError
        raise UnknownSpecialBadgeTypeError, "Unknown special badge type: #{badge_type}"
      end
    end
  end
end