module Resolvers
  class FetchQuests < BaseResolver
    type [Types::QuestType], null: false

    def resolve
      Questing::Queries::AllQuests.call
    end
  end
end
