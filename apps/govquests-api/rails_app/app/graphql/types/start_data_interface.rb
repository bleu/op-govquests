module Types
  module StartDataInterface
    include Types::BaseInterface
    description "An interface for different start data types based on action type"

    field :action_type, String, null: false, description: "Type of the action"

    orphan_types Types::GitcoinScoreStartDataType, Types::ReadDocumentStartDataType

    def self.resolve_type(object, _context)
      action_type = object["action_type"]
      case action_type
      when "gitcoin_score"
        Types::GitcoinScoreStartDataType
      when "read_document"
        Types::ReadDocumentStartDataType
      else
        Types::ReadDocumentStartDataType
      end
    end
  end
end
