module Types
  class EnsCompletionDataType < Types::BaseObject
    implements Types::CompletionDataInterface

    description "Completion data for ENS action"

    def action_type
      "ens"
    end
  end
end
