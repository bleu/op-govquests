# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include ActionPolicy::GraphQL::Behaviour
  end
end
