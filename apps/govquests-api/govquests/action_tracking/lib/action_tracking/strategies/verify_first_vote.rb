require_relative "base"

module ActionTracking
  module Strategies
    class VerifyFirstVote < Base
      def on_start_execution
        {
          proposalsVotedOn: agora_delegate["proposalsVotedOn"].to_i
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
        (start_data["proposalsVotedOn"] || 0) > 0
      end

      def agora_delegate
        @agora_delegate ||= AgoraApi::Client.new.get_delegate(start_data[:address])
      end
    end
  end
end