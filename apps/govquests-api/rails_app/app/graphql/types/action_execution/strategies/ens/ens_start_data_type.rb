module Types
  class ActionExecution::Strategies::Ens::EnsStartDataType < Types::BaseObject
    implements Types::StartDataInterface

    description "Completion data for ENS action"
    field :domains, [Types::ActionExecution::Strategies::Ens::EnsDomainType], null: false, description: "List of domains to claim"

    def action_type
      "ens"
    end
  end
end
