module Types
  module CompletionDataInterface
    include Types::BaseInterface
    description "An interface for different completion data types"

    field :action_type, String, null: false, description: "Type of the action"
    field :address, String, null: true
    field :signature, String, null: true
    field :nonce, String, null: true

    orphan_types Types::GitcoinScoreCompletionDataType, Types::ReadDocumentCompletionDataType

    def self.resolve_type(object, _context)
      action_type = object["action_type"]
      case action_type
      when "gitcoin_score"
        Types::GitcoinScoreCompletionDataType
      when "read_document"
        Types::ReadDocumentCompletionDataType
      else
        Types::ReadDocumentCompletionDataType
      end
    end
  end
end
