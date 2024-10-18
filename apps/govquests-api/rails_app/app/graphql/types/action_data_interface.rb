module Types
  module ActionDataInterface
    include Types::BaseInterface
    description "An interface for different action data types"

    field :action_type, String, null: false, description: "Type of the action"

    orphan_types Types::GitcoinScoreActionDataType, Types::ReadDocumentActionDataType, Types::EnsActionDataType

    def self.resolve_type(object, _context)
      action_type = object["action_type"]
      case action_type
      when "gitcoin_score"
        Types::GitcoinScoreActionDataType
      when "read_document"
        Types::ReadDocumentActionDataType
      when "ens"
        Types::EnsActionDataType
      else
        Types::ReadDocumentActionDataType
      end
    end
  end
end
