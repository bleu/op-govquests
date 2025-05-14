module Processes
  class TriggerPosthogOnProposalCreated
    def initialize(event_store, command_bus)
      @event_store = event_store
      @command_bus = command_bus
    end
      
    def subscribe
      @event_store.subscribe(self, to: [Proposals::ProposalCreated])
    end

    def call(event)
      PosthogTrackingService.track_event("proposal_created", {
        proposal_id: event.data[:proposal_id],
        title: event.data[:title],
        status: event.data[:status],
        start_date: event.data[:start_date],
        end_date: event.data[:end_date]
      }, event.data[:proposal_id])
    end
  end
end