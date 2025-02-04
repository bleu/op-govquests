module ActionTracking
  module Strategies
    class BecomeDelegator < Base
      include Import['services.agora']

      def on_start_execution
        {
          delegatees:
        }
      end

      def start_data_valid?
        start_data[:address].present? && has_delegated?
      end

      def can_complete?
        start_data_valid?
      end

      private

      def has_delegated?
        delegatees.any?
      end

      def delegatees
        @delegatees ||= agora.get_delegatees(start_data[:address])
      end
    end
  end
end
