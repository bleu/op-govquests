require_relative "base"

module ActionTracking
  module Strategies
    class VerifyFirstVote < Base
      include Infra::Import["services.agora"]

      def on_start_execution
        {
          proposals_voted_on: agora_delegate["proposals_voted_on"].to_i
        }
      end

      def start_data_valid?
        start_data[:address].present? && has_any_vote?
      end

      def can_complete?
        start_data_valid?
      end

      private

      def has_any_vote?
        (agora_delegate["proposals_voted_on"].to_i || 0) > 0
      end

      def agora_delegate
        @agora_delegate ||= agora.get_delegate(start_data[:address])
      end
    end
  end
end
