module Resolvers
  class FetchQuest < BaseResolver
    type Types::QuestType, null: true

    argument :slug, String, required: true

    def resolve(slug:)
      Questing::Queries::FindQuest.call(slug)
    end
  end
end
