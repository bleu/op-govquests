module Types
  module Inputs
    class SendEmailVerificationInput < Types::BaseInputObject
      description "Input type for email-related actions"
      argument :email, String, required: false
    end
  end
end
