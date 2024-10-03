module Questing
  class OnQuestCreated
    def call(event)
      QuestReadModel.find_or_initialize_by(quest_id: event.data[:quest_id]).tap do |quest|
        quest.update!(
          audience: event.data[:audience],
          quest_type: event.data[:quest_type],
          duration: event.data[:duration],
          difficulty: event.data[:difficulty],
          requirements: event.data[:requirements],
          reward: event.data[:reward],
          subquests: event.data[:subquests],
          status: "created"
        )
      end
    end
  end
end
