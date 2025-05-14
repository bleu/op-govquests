module Proposals
  class NotifyEndingProposalsService
    def call
      proposals = ProposalReadModel.close_to_end

      proposals.each do |proposal|
        proposal_id = proposal.proposal_id
        proposal_title = proposal.title

        users_to_notify = Authentication::UserReadModel.where(user_type: "delegate")

        users_to_notify.each do |user|
          command = ::Notifications::CreateNotification.new(
            user_id: user.id,
            notification_id: SecureRandom.uuid,
            content: "Don’t miss out! Less than 48 hours left to cast your vote in <a href='https://vote.optimism.io/proposals/#{proposal_id}' target='_blank'>#{proposal_title}</a>.",
            notification_type: "proposal_ending_soon",
            delivery_methods: ["in_app", "email", "telegram"],
            cta_text: "Vote Now",
            cta_url: "https://vote.optimism.io/proposals/#{proposal_id}"
          )

          Rails.configuration.command_bus.call(command)
        rescue => e
          Appsignal.send_error(e) do |transaction|
            transaction.set_namespace("background_job")
            transaction.set_tags(
              job: self.class.name,
              queue: queue_name,
              proposal_id: proposal_id
            )
            transaction.set_params(
              original_error: e.class.name,
              proposal: proposal
            )
          end
        end
      end
    end
  end
end
