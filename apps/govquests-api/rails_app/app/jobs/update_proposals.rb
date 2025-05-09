class UpdateProposalsJob < ApplicationJob
  def perform
    all_proposals = AgoraApi::Proposals.new.fetch_all_proposals

    active_proposals = all_proposals.filter do |proposal|
      proposal["status"] == "active"
    end

    active_proposals.each do |proposal|
      command = ::Proposals::CreateProposal.new(
        proposal_id: proposal["id"],
        title: proposal["title"],
        description: proposal["description"],
        status: proposal["status"],
        created_at: proposal["created_at"],
        updated_at: proposal["updated_at"]
      )

      Rails.configuration.command_bus.call(command)
    rescue ::Proposals::ProposalAlreadyCreated
      # Proposal already exists, do nothing
    rescue => e
      error_message = "Failed to update proposal #{proposal["id"]}: #{e.message}"
      Rails.logger.error error_message

      Appsignal.send_error(e) do |transaction|
        transaction.set_namespace("background_job")
        transaction.set_tags(
          job: self.class.name,
          queue: queue_name,
          proposal_id: proposal["id"]
        )
        transaction.set_params(
          original_error: e.class.name,
          proposal: proposal
        )
      end
    end
  end
end
