module Proposals 
  class Proposal
    include AggregateRoot

    def initialize(id)
      @id = id
      @title = nil
      @description = nil
      @status = nil
      @start_date = nil
      @end_date = nil
    end

    def create(title, description, status, start_date, end_date)
      raise "Proposal already created" if @id

      apply ProposalCreated.new(data: {
        proposal_id: @id,
        title: title,
        description: description,
        status: status,
        start_date: start_date,
        end_date: end_date
      })
    end

    private

    def on_proposal_created(event)
      @title = event.data[:title]
      @description = event.data[:description]
      @status = event.data[:status]
      @start_date = event.data[:start_date]
      @end_date = event.data[:end_date]
    end
  end
end