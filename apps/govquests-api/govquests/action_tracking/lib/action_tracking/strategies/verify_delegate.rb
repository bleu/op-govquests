require_relative "base"

module ActionTracking
  module Strategies
    class VerifyDelegate < Base
      include Import["services.agora"]

      def on_start_execution
        {
          votingPower: agora_delegate["votingPower"]
        }
      end

      def start_data_valid?
        start_data[:address].present?
      end

      def can_complete?
        start_data_valid? && verify_voting_power?
      end

      private

      def verify_voting_power?
        (start_data["votingPower"]["total"]&.to_i || 0) > 0
      end

      def agora_delegate
        @agora_delegate ||= agora.get_delegate(start_data[:address])
      end
    end
  end
end
