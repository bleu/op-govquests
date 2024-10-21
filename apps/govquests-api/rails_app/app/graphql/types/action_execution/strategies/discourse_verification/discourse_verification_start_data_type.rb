module Types
  module ActionExecution
    module Strategies
      module DiscourseVerification
        class DiscourseVerificationStartDataType < Types::BaseObject
          implements Types::StartDataInterface
          description "Start data for Discourse verification action"

          field :verification_url, String, null: false

          def action_type
            "discourse_verification"
          end
        end
      end
    end
  end
end
