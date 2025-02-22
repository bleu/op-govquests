require_relative "base"

module ActionTracking
  module Strategies
    class VerifyDelegate < Base
      include Infra::Import["services.agora"]

      def on_start_execution
        {
          votingPower: agora_delegate["votingPower"]
        }
      end

      def start_data_valid?
        start_data[:address].present? && verify_voting_power?
      end

      def can_complete?
        start_data_valid?
      end

      private

      def verify_voting_power?
        (agora_delegate["votingPower"]["total"]&.to_i || 0) > 0
      end

      def agora_delegate
        @agora_delegate ||= agora.get_delegate(start_data[:address])
      end
    end
  end
end
