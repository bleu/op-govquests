module Proposals
  class OnProposalCreated
    def call(event)
      ProposalReadModel.create!(
        proposal_id: event.data[:proposal_id],
        title: event.data[:title],
        description: event.data[:description],
        status: event.data[:status],
        start_date: event.data[:start_date],
        end_date: event.data[:end_date]
      )
    end
  end
end
