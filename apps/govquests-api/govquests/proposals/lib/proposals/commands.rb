module Proposals
  class CreateProposal < Infra::Command
    attribute :proposal_id, Infra::Types::String
    attribute :title, Infra::Types::String
    attribute :description, Infra::Types::String
    attribute :status, Infra::Types::String
    attribute :start_date, Infra::Types::DateTime
    attribute :end_date, Infra::Types::DateTime

    alias_method :aggregate_id, :proposal_id
  end
end
