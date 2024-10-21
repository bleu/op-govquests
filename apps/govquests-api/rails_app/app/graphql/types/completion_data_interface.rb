# app/graphql/types/completion_data_interface.rb
module Types
  module CompletionDataInterface
    include Types::BaseInterface
    description "An interface for different completion data types"

    field :action_type, String, null: false, description: "Type of the action"

    orphan_types Types::GitcoinScoreCompletionDataType,
      Types::ReadDocumentCompletionDataType,
      Types::EnsCompletionDataType,
      Types::ActionExecution::Strategies::DiscourseVerification::DiscourseVerificationCompletionDataType

    def self.resolve_type(object, _context)
      action_type = object["action_type"]
      case action_type
      when "gitcoin_score"
        Types::GitcoinScoreCompletionDataType
      when "read_document"
        Types::ReadDocumentCompletionDataType
      when "ens"
        Types::EnsCompletionDataType
      when "discourse_verification"
        Types::ActionExecution::Strategies::DiscourseVerification::DiscourseVerificationCompletionDataType
      else
        Types::ReadDocumentCompletionDataType
      end
    end
  end
end
