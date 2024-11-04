# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Action Tracking
    field :start_action_execution, mutation: Mutations::StartActionExecution, preauthorize: {with: AuthenticatedGraphqlPolicy}
    field :complete_action_execution, mutation: Mutations::CompleteActionExecution, preauthorize: {with: AuthenticatedGraphqlPolicy}
    # field :start_claim, mutation: Mutations::StartClaim

    # Authentication
    field :generate_siwe_message, mutation: Mutations::GenerateSiweMessage
    field :sign_in_with_ethereum, mutation: Mutations::SignInWithEthereum
    field :sign_out, mutation: Mutations::SignOut
  end
end
