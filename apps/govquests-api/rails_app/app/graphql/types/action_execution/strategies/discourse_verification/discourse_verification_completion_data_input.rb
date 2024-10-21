module Types
  module ActionExecution
    module Strategies
      module DiscourseVerification
        class DiscourseVerificationCompletionDataInput < Types::BaseInputObject
          description "Completion data input for Discourse verification action"

          argument :encrypted_key, String, required: true
        end
      end
    end
  end
end
