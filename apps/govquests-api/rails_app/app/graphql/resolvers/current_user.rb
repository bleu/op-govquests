module Resolvers
  class CurrentUser < BaseResolver
    type Types::UserType, null: true

    def resolve
      context[:current_user]
    end
  end
end
