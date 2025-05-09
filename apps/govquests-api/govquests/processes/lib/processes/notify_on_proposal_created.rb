module Processes
  class NotifyOnProposalCreated
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end

    def subscribe
      @event_store.subscribe(self, to: [::Proposals::ProposalCreated])
    end

    def call(event)
      proposal_id = event.data[:proposal_id]
      proposal_name = event.data[:title]

      Authentication::UserReadModel.where(user_type: "delegate").find_each do |user|
        @command_bus.call(
          ::Notifications::CreateNotification.new(
            user_id: user.user_id,
            notification_id: SecureRandom.uuid,
            content: "The voting for <a href='https://vote.optimism.io/proposals/#{proposal_id}' target='_blank'>#{proposal_name}</a> has officially started. Make your voice heard and cast your vote today!",
            notification_type: "proposal_created",
            delivery_methods: ["in_app", "email", "telegram"],
            cta_text: "Vote Now",
            cta_url: "https://vote.optimism.io/proposals/#{proposal_id}",
          )
        )
      end
    end

    private
  end
end
