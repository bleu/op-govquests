module Quests
  class CreateQuest
    def call(event)
      quest_id = event.data.fetch(:quest_id)
      Quest.find_or_create_by(quest_id: quest_id)
    end
  end
end
