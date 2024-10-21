module Types
  module ActionExecution
    module Strategies
      module DiscourseVerification
        class DiscourseVerificationActionDataType < Types::BaseObject
          implements Types::ActionDataInterface
          description "Action data for Discourse verification action"

          def action_type
            "discourse_verification"
          end
        end
      end
    end
  end
end
