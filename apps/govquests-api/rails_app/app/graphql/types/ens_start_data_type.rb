module Types
  class EnsStartDataType < Types::BaseObject
    implements Types::StartDataInterface

    description "Completion data for ENS action"
    field :domains, [String], null: false, description: "List of domains to claim"

    def action_type
      "ens"
    end
  end
end
