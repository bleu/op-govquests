require_relative "action_strategy"

module ActionTracking
  class ProposalVoteActionStrategy < ActionStrategy
    private

    def action_type
      "proposal_vote"
    end

    def description
      "Vote on a governance proposal"
    end

    def action_data(data)
      {proposal_id: data[:proposal_id]}
    end

    def verify_completion(data)
      proposal_id = data[:proposal_id]
      user_address = data[:user_address]

      agora_client = AgoraApi::Client.new
      votes = agora_client.get_proposal_votes(proposal_id)

      votes["data"].any? { |vote| vote["voter"].downcase == user_address.downcase }
    rescue AgoraApi::Error => e
      Rails.logger.error "Failed to verify vote: #{e.message}"
      false
    end
  end
end
