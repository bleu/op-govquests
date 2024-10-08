# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :start_action_execution, mutation: Mutations::StartActionExecution
    field :complete_action_execution, mutation: Mutations::CompleteActionExecution
  end
end
