module Types
  module StartDataInterface
    include Types::BaseInterface
    description "An interface for different start data types based on action type"

    field :action_type, String, null: false, description: "Type of the action"

    orphan_types Types::GitcoinScoreStartDataType,
      Types::ActionExecution::Strategies::DiscourseVerification::DiscourseVerificationStartDataType,
      Types::SendEmailStartDataType,
      Types::ActionExecution::EmptyActionStartDataType

    def self.resolve_type(object, _context)
      action_type = object["action_type"]
      case action_type
      when "gitcoin_score"
        Types::GitcoinScoreStartDataType
      when "discourse_verification"
        Types::ActionExecution::Strategies::DiscourseVerification::DiscourseVerificationStartDataType
      when "send_email"
        Types::SendEmailStartDataType
      else
        Types::ActionExecution::EmptyActionStartDataType
      end
    end
  end
end
