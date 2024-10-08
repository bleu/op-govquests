module Resolvers
  class FetchQuest < BaseResolver
    type Types::QuestType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      Questing::Queries::FindQuest.call(id)
    end
  end
end
