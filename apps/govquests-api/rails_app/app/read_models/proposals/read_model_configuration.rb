module Proposals
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnProposalCreated, to: [Proposals::ProposalCreated])
    end
  end
end
