module Types
  class EnsActionDataType < Types::BaseObject
    description "Action data for ENS action"

    def action_type
      "ens"
    end
  end
end
