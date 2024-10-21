module Types
  module ActionExecution
    module Strategies
      module DiscourseVerification
        class DiscourseVerificationCompletionDataType < Types::BaseObject
          implements Types::CompletionDataInterface
          description "Completion data for Discourse verification action"

          field :discourse_username, String, null: false

          def action_type
            "discourse_verification"
          end
        end
      end
    end
  end
end
