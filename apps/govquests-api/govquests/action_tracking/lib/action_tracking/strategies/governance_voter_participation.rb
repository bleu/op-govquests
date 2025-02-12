require_relative "base"

module ActionTracking
  module Strategies
    class GovernanceVoterParticipation < Base
      include Infra::Import["services.agora"]

      def on_start_execution
        {
          consecutive_proposals_voted: consecutive_proposals_voted(3)
        }
      end

      def start_data_valid?
        start_data[:address].present?
      end

      def can_complete?
        start_data_valid? && has_three_consecutive_votes?
      end

      private

      def has_three_consecutive_votes?
        consecutive_proposals_voted(3).present?
      end

      def consecutive_proposals_voted(n = 3)
        ordered_proposal_ids.each_cons(n) do |window|
          return window if window.all? { |id| vote_set.include?(id) }
        end

        []
      end

      def ordered_proposal_ids
        @ordered_proposal_ids ||= proposals.sort_by { |p| p["endTime"] }.map { |p| p["id"] }
      end

      def vote_set
        @vote_set ||= Set.new(
          votes.map { |vote| vote["proposalId"] }
        )
      end

      def votes
        @votes ||= agora.fetch_all_delegate_votes(start_data[:address])
      end

      def proposals
        @proposals ||= agora.fetch_all_proposals
      end
    end
  end
end
