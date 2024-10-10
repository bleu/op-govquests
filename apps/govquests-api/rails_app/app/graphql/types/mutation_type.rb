# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :start_action_execution, mutation: Mutations::StartActionExecution
    field :complete_action_execution, mutation: Mutations::CompleteActionExecution
    field :generate_siwe_message, mutation: Mutations::GenerateSiweMessage
    field :sign_in_with_ethereum, mutation: Mutations::SignInWithEthereum
    field :sign_out, mutation: Mutations::SignOut
  end
end
