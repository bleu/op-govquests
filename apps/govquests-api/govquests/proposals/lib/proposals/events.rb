module Proposals
  class ProposalCreated < Infra::Event
    attribute :proposal_id, Infra::Types::String
    attribute :title, Infra::Types::String
    attribute :description, Infra::Types::String
    attribute :status, Infra::Types::String
    attribute :start_date, Infra::Types::DateTime
    attribute :end_date, Infra::Types::DateTime
  end
end
