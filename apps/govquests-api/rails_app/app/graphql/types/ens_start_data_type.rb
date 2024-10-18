module Types
  class EnsStartDataType < Types::BaseObject
    implements Types::StartDataInterface
    description "Start data for ENS action"

    field :address, String, null: false

    def action_type
      "ens"
    end
  end
end
